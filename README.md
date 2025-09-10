# Laravel Chat App (Docker + Reverb)

A Laravel 11 chat application with authentication, MySQL, and real-time messaging powered by [Laravel Reverb](https://laravel.com/docs/master/reverb) (WebSockets).  
Fully containerized with Docker for easy local development.

---

## 🚀 Features

- User registration & login (Laravel Breeze, Blade)
- Real-time chat with Laravel Reverb + Echo + Pusher protocol
- MySQL database (via Docker)
- Vite/Tailwind frontend build
- One-command bootstrap script (`init.ps1`)

---

## 📦 Prerequisites

- **Windows 10/11** with [Docker Desktop](https://www.docker.com/products/docker-desktop/) (WSL2 backend recommended)
- **Git**
- PowerShell 5+  
*(No local PHP/Composer/Node required — all runs inside Docker)*

---

## ⚙️ Installation (fresh setup)

1. Clone this repository:

   ```powershell
   git clone https://github.com/<your-username>/<your-repo>.git
   cd <your-repo>
   ```

2. Run the bootstrap script:

   ```powershell
   .\init.ps1
   ```

   This will:
   - Build Docker images
   - Generate `.env` with proper DB/Reverb config
   - Generate `APP_KEY`
   - Fix permissions for `storage/` and `bootstrap/cache/`
   - Install **Breeze** (auth pages)
   - Install & build frontend (Vite)
   - Install **Reverb** broadcasting
   - Run database migrations
   - Start all containers (`app`, `db`, `nginx`, `reverb`)

3. Open the app in your browser:

   - App home: [http://localhost:8080](http://localhost:8080)  
   - Register: [http://localhost:8080/register](http://localhost:8080/register)  
   - Chat: [http://localhost:8080/chat](http://localhost:8080/chat)

---

## 🗄️ Database Access

You can connect with [DBeaver](https://dbeaver.io/) or any MySQL client:

- **Host**: `localhost`
- **Port**: `3307`
- **Database**: `chatapp`
- **Username**: `chatuser`
- **Password**: `chatpass`

*(These values come from `docker-compose.yml` and `.env`.)*

---

## 🔧 Daily Development

Rebuild frontend assets after JS/CSS changes:

```powershell
docker compose run --rm -T app npm run build
```

Run artisan commands:

```powershell
docker compose run --rm app php artisan <command>
```

View logs:

```powershell
docker compose logs -f app
docker compose logs -f reverb
```

Stop all containers:

```powershell
docker compose down
```

---

**Slow performance on Windows**  
- Use named volumes for `storage/` and `bootstrap/cache/`.  
- Enable OPcache in your PHP container.  
- Give Docker Desktop 4+ CPUs and 4–8 GB RAM.  
- Run the project from WSL2 filesystem instead of `C:\`.

---

## 📜 License

MIT
