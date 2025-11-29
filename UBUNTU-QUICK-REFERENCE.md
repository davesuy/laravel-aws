# ⚡ Quick Ubuntu Commands - Laravel AWS Setup

## Your EC2 instance is running Ubuntu (not Amazon Linux)!

**Key Differences:**
- Package manager: `apt` (not `dnf` or `yum`)
- Web server user: `www-data` (not `nginx` or `apache`)
- PHP-FPM service: `php8.3-fpm` (not `php-fpm`)
- PHP-FPM socket: `/var/run/php/php-fpm.sock` (not `/var/run/php-fpm/www.sock`)
- Nginx sites: `/etc/nginx/sites-available/` (not `/etc/nginx/conf.d/`)

---

## Complete Setup Commands (Copy-Paste)

### Step 1: Update System & Install Packages

**Important**: Ubuntu 22.04 ships with PHP 8.1, but Laravel requires PHP 8.2+. Install PHP 8.3 from ondrej/php PPA.

```bash
# Update system
sudo apt update -y && sudo apt upgrade -y

# Add PHP 8.3 repository
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update

# Install PHP 8.3 and all required extensions
sudo apt install -y \
  php8.3 \
  php8.3-cli \
  php8.3-fpm \
  php8.3-mysql \
  php8.3-mbstring \
  php8.3-xml \
  php8.3-gd \
  php8.3-curl \
  php8.3-zip \
  php8.3-bcmath \
  php8.3-tokenizer \
  php8.3-sqlite3 \
  nginx \
  git \
  unzip \
  curl

# Set PHP 8.3 as default
sudo update-alternatives --set php /usr/bin/php8.3

# Verify PHP version
php -v
# Should show PHP 8.3.x (NOT 8.1.x)
```

### Step 2: Install Composer

```bash
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer
composer --version
```

### Step 3: Create Laravel Directory

```bash
sudo mkdir -p /var/www/laravel/public
sudo chown -R www-data:www-data /var/www/laravel
```

### Step 4: Configure Nginx

```bash
# Create Nginx site configuration
sudo tee /etc/nginx/sites-available/laravel > /dev/null <<'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    root /var/www/laravel/public;
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
EOF

# Remove default site and enable Laravel
sudo rm -f /etc/nginx/sites-enabled/default
sudo ln -sf /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/

# Test and restart
sudo nginx -t
sudo systemctl restart php8.3-fpm nginx
sudo systemctl enable php8.3-fpm nginx
```

### Step 5: Clone Your Laravel App

```bash
cd /var/www/laravel
sudo git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git temp
sudo cp -r temp/* .
sudo cp -r temp/.* . 2>/dev/null || true
sudo rm -rf temp
```

### Step 6: Install Dependencies

```bash
cd /var/www/laravel
sudo composer install --no-dev --optimize-autoloader
```

### Step 7: Configure Environment

```bash
# Create SQLite database
sudo mkdir -p database
sudo touch database/database.sqlite
sudo chmod 664 database/database.sqlite

# Copy environment file
sudo cp .env.example .env

# Generate app key
sudo php artisan key:generate

# Edit .env (replace YOUR_PUBLIC_IP with your actual IP)
sudo nano .env
```

**In .env, set:**
```env
APP_ENV=production
APP_DEBUG=false
APP_URL=http://YOUR_PUBLIC_IP

DB_CONNECTION=sqlite
DB_DATABASE=/var/www/laravel/database/database.sqlite
```

### Step 8: Run Migrations

```bash
sudo php artisan migrate --force
```

### Step 9: Set Permissions

```bash
# Set ownership to www-data
sudo chown -R www-data:www-data /var/www/laravel

# Set directory permissions
sudo find /var/www/laravel -type d -exec chmod 755 {} \;
sudo find /var/www/laravel -type f -exec chmod 644 {} \;

# Set storage and cache permissions
sudo chmod -R 775 /var/www/laravel/storage
sudo chmod -R 775 /var/www/laravel/bootstrap/cache
sudo chmod 664 /var/www/laravel/database/database.sqlite

# Create storage link
sudo php artisan storage:link
```

### Step 10: Optimize for Production

```bash
sudo php artisan config:cache
sudo php artisan route:cache
sudo php artisan view:cache
```

### Step 11: Final Restart

```bash
sudo systemctl restart php8.3-fpm nginx
```

### Step 12: Test

```bash
# Test locally
curl http://localhost

# Check logs if needed
sudo tail -f /var/log/nginx/error.log
```

---

## Common Service Commands

```bash
# Restart services
sudo systemctl restart nginx
sudo systemctl restart php8.3-fpm

# Check status
sudo systemctl status nginx
sudo systemctl status php8.3-fpm

# View logs
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log
tail -f /var/www/laravel/storage/logs/laravel.log

# Check PHP version
php -v

# Check Nginx configuration
sudo nginx -t
```

---

## Troubleshooting

### If PHP version is different (e.g., PHP 8.1):

```bash
# Find your PHP version
php -v

# Use the correct service name:
sudo systemctl restart php8.1-fpm    # for PHP 8.1
sudo systemctl restart php8.2-fpm    # for PHP 8.2
sudo systemctl restart php8.3-fpm    # for PHP 8.3

# Update Nginx config to use correct socket:
sudo nano /etc/nginx/sites-available/laravel
# Change: fastcgi_pass unix:/var/run/php/php8.X-fpm.sock;
```

### 502 Bad Gateway:

```bash
# Check PHP-FPM is running
sudo systemctl status php8.3-fpm

# Check socket exists
ls -la /var/run/php/

# Restart services
sudo systemctl restart php8.3-fpm nginx
```

### Permission Denied errors:

```bash
sudo chown -R www-data:www-data /var/www/laravel
sudo chmod -R 775 /var/www/laravel/storage
sudo chmod -R 775 /var/www/laravel/bootstrap/cache
```

---

## Quick Test Script

Run this to verify your setup:

```bash
echo "=== PHP Version ==="
php -v

echo -e "\n=== Nginx Status ==="
sudo systemctl status nginx --no-pager

echo -e "\n=== PHP-FPM Status ==="
sudo systemctl status php8.3-fpm --no-pager

echo -e "\n=== PHP Socket ==="
ls -la /var/run/php/

echo -e "\n=== Web Directory ==="
ls -la /var/www/laravel/

echo -e "\n=== Test Local Connection ==="
curl -I http://localhost
```

---

**Full Guide**: See [MANUAL-SETUP-GUIDE.md](MANUAL-SETUP-GUIDE.md) for detailed instructions.

