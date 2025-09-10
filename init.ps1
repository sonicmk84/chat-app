# Requires: PowerShell 5+ (Windows), Docker Desktop running
# Purpose: Fresh install + bootstrap of the Laravel + MySQL + Reverb (WebSockets) stack inside Docker.

$ErrorActionPreference = "Stop"

Write-Host "Initializing Laravel chat app..."

# 0) Quick preflight checks
Write-Host "Checking Docker..."
docker version *> $null

# 1) Reset src/ (fresh install)
if (Test-Path "src") {
    Write-Host "Cleaning ./src ..."
    Remove-Item -Recurse -Force "src"
}
New-Item -ItemType Directory -Path "src" | Out-Null

# 2) Build containers
Write-Host "Building Docker images..."
docker compose build

# 3) Create a fresh Laravel app into ./src
Write-Host "Installing Laravel into ./src ..."
docker compose run --rm app composer create-project laravel/laravel .

# 4) Create .env (overwrite with project-required settings)
Write-Host "Creating .env ..."
$envPath = "src/.env"
@"
APP_NAME=Laravel
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost

APP_LOCALE=en
APP_FALLBACK_LOCALE=en
APP_FAKER_LOCALE=en_US

APP_MAINTENANCE_DRIVER=file
PHP_CLI_SERVER_WORKERS=4
BCRYPT_ROUNDS=12

LOG_CHANNEL=stack
LOG_STACK=single
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

# ---------------------------
# Database (container-to-container)
# ---------------------------
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=chatapp
DB_USERNAME=chatuser
DB_PASSWORD=chatpass

# ---------------------------
# Session / Cache / Queue (fast dev defaults)
# ---------------------------
SESSION_DRIVER=file
SESSION_LIFETIME=120
SESSION_ENCRYPT=false
SESSION_PATH=/
SESSION_DOMAIN=null

CACHE_STORE=file
CACHE_DRIVER=file
QUEUE_CONNECTION=sync

# ---------------------------
# Broadcast (Laravel Reverb)
# ---------------------------
BROADCAST_DRIVER=reverb
BROADCAST_CONNECTION=reverb

REVERB_APP_ID=local
REVERB_APP_KEY=local
REVERB_APP_SECRET=local

# SERVER (PHP container) -> REVERB (container)
REVERB_HOST=reverb
REVERB_PORT=6001
REVERB_SCHEME=http

# Reverb bind inside container
REVERB_SERVER_HOST=0.0.0.0
REVERB_SERVER_PORT=6001

# BROWSER (your PC) -> REVERB (host mapped port)
VITE_REVERB_APP_KEY=\${REVERB_APP_KEY}
VITE_REVERB_HOST=127.0.0.1
VITE_REVERB_PORT=\${REVERB_PORT}
VITE_REVERB_SCHEME=\${REVERB_SCHEME}

# Allow both origins
REVERB_ALLOWED_ORIGINS=http://127.0.0.1:8080,http://localhost:8080

# ---------------------------
# Redis (unused in dev)
# ---------------------------
REDIS_CLIENT=phpredis
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

# ---------------------------
# Mail (dummy in dev)
# ---------------------------
MAIL_MAILER=log
MAIL_SCHEME=null
MAIL_HOST=127.0.0.1
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="\${APP_NAME}"

# ---------------------------
# Vite
# ---------------------------
VITE_APP_NAME="\${APP_NAME}"
"@ | Set-Content -Encoding UTF8 $envPath

# 5) Key + permissions for storage/cache (works for bind-mount or named volumes)
Write-Host "Generating app key..."
docker compose run --rm app php artisan key:generate

Write-Host "Ensuring storage/bootstrap permissions..."
docker compose run --rm app bash -lc "mkdir -p storage/framework/{cache,sessions,views} bootstrap/cache && chmod -R 777 storage bootstrap/cache"

# 6) Install Breeze auth (Blade) + build assets
Write-Host "Installing Laravel Breeze..."
docker compose run --rm app composer require laravel/breeze --dev
docker compose run --rm app php artisan breeze:install blade

Write-Host "Installing npm dependencies..."
docker compose run --rm -T app npm install

Write-Host "Building frontend (Vite)..."
docker compose run --rm -T app npm run build

# 7) Install broadcasting (Reverb) scaffolding (safe to re-run)
Write-Host "Installing broadcasting (Reverb)..."
docker compose run --rm app php artisan install:broadcasting --reverb

# 8) Database migrations
Write-Host "Running migrations..."
docker compose run --rm app php artisan migrate

# 9) Clear caches
Write-Host "Clearing caches..."
docker compose run --rm app php artisan config:clear
docker compose run --rm app php artisan cache:clear
docker compose run --rm app php artisan view:clear

# 10) Start core services + Reverb
Write-Host "Starting containers..."
docker compose up -d
docker compose up -d reverb

# 11) Final checks
Write-Host ""
Write-Host "Done!"
Write-Host "App:      http://localhost:8080"
Write-Host "Register: http://localhost:8080/register"
Write-Host "Chat:     http://localhost:8080/chat"
