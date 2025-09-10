Write-Host "Initializing Laravel project in ./src ..."

# Step 1. Remove old src (if exists)
if (Test-Path "src") {
    Write-Host "Removing old src folder..."
    Remove-Item -Recurse -Force "src"
}
New-Item -ItemType Directory -Path "src" | Out-Null

# Step 2. Build containers
Write-Host "Building Docker containers..."
docker compose build

# Step 3. Create Laravel project
Write-Host "Installing Laravel into ./src ..."
docker compose run --rm app composer create-project laravel/laravel .

# Step 4. Fix permissions for Laravel
Write-Host "Fixing permissions..."
docker compose run --rm app chmod -R 777 storage bootstrap/cache

# Step 5. Install Laravel Breeze
Write-Host "Installing Laravel Breeze..."
docker compose run --rm app composer require laravel/breeze --dev
docker compose run --rm app php artisan breeze:install blade

# Step 6. Frontend build
Write-Host "Installing npm dependencies..."
docker compose run --rm -T app npm install
Write-Host "Building frontend..."
docker compose run --rm -T app npm run build

# Step 7. Generate app key
Write-Host "Generating app key..."
docker compose run --rm app php artisan key:generate

# Step 8. Run migrations
Write-Host "Running database migrations..."
docker compose run --rm app php artisan migrate

# Step 9. Start everything
Write-Host "Starting containers..."
docker compose up -d

# Final message
Write-Host ""
Write-Host "Laravel project initialized!"
Write-Host "Open http://localhost:8080/register to test registration."
Write-Host "Open http://localhost:8080/login to test login."
