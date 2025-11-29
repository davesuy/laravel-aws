# 🔧 PHP Version & Composer Dependency Fixes

## Common Issues:

### Issue 1: brick/math requires PHP 8.2+
### Issue 2: Symfony 8.0 requires PHP 8.4+ 

---

## ❌ Problem 1: PHP 8.1 (brick/math requires PHP 8.2+)

You're getting this error when running `composer install`:

```
Problem 22
- ramsey/uuid is locked to version 4.9.1 and an update of this package was not requested.
- brick/math 0.14.1 requires php ^8.2 -> your php version (8.1.2) does not satisfy that requirement.
- ramsey/uuid 4.9.1 requires brick/math ^0.8.8 || ^0.9 || ^0.10 || ^0.11 || ^0.12 || ^0.13 || ^0.14 -> satisfiable by brick/math[0.14.1]
```

**Root Cause**: Ubuntu 22.04 LTS ships with PHP 8.1, but your Laravel project requires PHP 8.2+.

---

## ❌ Problem 2: Symfony 8.0 requires PHP 8.4+

You're getting this error when running `composer install`:

```
Problem 1
  - symfony/event-dispatcher v8.0.0 requires php >=8.4 -> your php version (8.3.28) does not satisfy that requirement.
Problem 2
  - symfony/string v8.0.0 requires php >=8.4 -> your php version (8.3.28) does not satisfy that requirement.
```

**Root Cause**: 
- Laravel 12 uses Symfony 8.0 components
- Symfony 8.0 requires PHP 8.4 (not released as stable yet)
- Your server has PHP 8.3 (current stable version)
- Solution: Use Laravel 11 with Symfony 7.x

---

## ✅ Solution for Symfony 8.0 Issue

### Option A: Pull Updated Repository (EASIEST)

The repository has been updated to use Laravel 11 with Symfony 7.x:

```bash
# On your EC2 instance
cd /var/www/laravel

# Pull the fixed version
sudo git pull origin main

# Install dependencies (should work now!)
sudo composer install --no-dev --optimize-autoloader
```

### Option B: Manual Fix on Server

If you need to fix it manually on the server:

```bash
cd /var/www/laravel

# Delete composer.lock
sudo rm composer.lock

# Install with Laravel 11 constraints
sudo composer install --no-dev --optimize-autoloader

# If that doesn't work, update to force Symfony 7.x:
sudo composer require "symfony/event-dispatcher:^7.0" "symfony/string:^7.0" --no-update
sudo composer update --no-dev --optimize-autoloader
```

---

## ✅ Solution for PHP 8.1 Issue (Upgrade to PHP 8.3)

### Step 1: Add PHP Repository

```bash
# Add ondrej/php PPA (provides newer PHP versions)
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
```

### Step 2: Install PHP 8.3

```bash
# Install PHP 8.3 with all required extensions
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
  php8.3-sqlite3
```

### Step 3: Set PHP 8.3 as Default

```bash
# Make PHP 8.3 the default version
sudo update-alternatives --set php /usr/bin/php8.3

# Verify it worked
php -v
# Should show: PHP 8.3.x
```

### Step 4: Update Nginx Configuration

```bash
# Update Nginx to use PHP 8.3 socket
sudo sed -i 's|fastcgi_pass unix:/var/run/php/php-fpm.sock;|fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;|g' /etc/nginx/sites-available/laravel

# Or if you manually configured it, edit the file:
sudo nano /etc/nginx/sites-available/laravel
# Change: fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
```

### Step 5: Restart Services

```bash
# Restart PHP-FPM and Nginx
sudo systemctl restart php8.3-fpm nginx

# Verify services are running
sudo systemctl status php8.3-fpm
sudo systemctl status nginx
```

### Step 6: Run Composer Again

```bash
# Now Composer should work
cd /var/www/laravel
sudo composer install --no-dev --optimize-autoloader
```

---

## 🎯 Quick One-Liner (If Starting Fresh)

If you haven't installed PHP yet, run this:

```bash
sudo apt update && \
sudo apt install -y software-properties-common && \
sudo add-apt-repository ppa:ondrej/php -y && \
sudo apt update && \
sudo apt install -y php8.3 php8.3-cli php8.3-fpm php8.3-mysql php8.3-mbstring php8.3-xml php8.3-gd php8.3-curl php8.3-zip php8.3-bcmath php8.3-tokenizer php8.3-sqlite3 nginx git unzip curl && \
sudo update-alternatives --set php /usr/bin/php8.3 && \
php -v
```

---

## 🔍 Verify Installation

```bash
# Check PHP version
php -v
# Expected: PHP 8.3.x

# Check PHP-FPM service
sudo systemctl status php8.3-fpm
# Expected: active (running)

# Check PHP socket exists
ls -la /var/run/php/
# Expected: php8.3-fpm.sock

# Test Composer
composer --version
# Expected: Composer version 2.x

# Try installing dependencies again
cd /var/www/laravel
sudo composer install --no-dev --optimize-autoloader
# Expected: Success!
```

---

## 🐛 Troubleshooting

### If `php -v` still shows PHP 8.1:

```bash
# List all PHP versions
ls /usr/bin/php*

# Manually set PHP 8.3 as default
sudo update-alternatives --config php
# Select php8.3 from the list

# Verify
php -v
```

### If Nginx gives 502 Bad Gateway after PHP upgrade:

```bash
# Make sure PHP 8.3-FPM is running
sudo systemctl status php8.3-fpm

# If not running, start it
sudo systemctl start php8.3-fpm
sudo systemctl enable php8.3-fpm

# Update Nginx config to use correct socket
sudo nano /etc/nginx/sites-available/laravel
# Ensure line says: fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;

# Test Nginx config
sudo nginx -t

# Restart both services
sudo systemctl restart php8.3-fpm nginx
```

### If Composer still fails with memory errors:

```bash
# Increase PHP memory limit
sudo php -d memory_limit=512M /usr/local/bin/composer install --no-dev --optimize-autoloader
```

### If you want to remove PHP 8.1:

```bash
# Remove PHP 8.1 (optional, after PHP 8.3 is working)
sudo apt purge -y php8.1* 
sudo apt autoremove -y

# Keep PHP 8.3 only
sudo apt install --install-recommends php8.3
```

---

## 📊 PHP Version Matrix

| Ubuntu Version | Default PHP | Status for Laravel 11+ |
|----------------|-------------|------------------------|
| Ubuntu 24.04 LTS | PHP 8.3 | ✅ Works |
| Ubuntu 22.04 LTS | PHP 8.1 | ❌ Too old - upgrade needed |
| Ubuntu 20.04 LTS | PHP 7.4 | ❌ Too old - upgrade needed |

**Recommendation**: Always use PHP 8.2+ for modern Laravel projects.

---

## 🚀 Complete Fresh Install (All Commands)

If you're starting from scratch on a fresh Ubuntu 22.04 EC2 instance:

```bash
#!/bin/bash
set -e

echo "=== Updating system ==="
sudo apt update -y && sudo apt upgrade -y

echo "=== Adding PHP 8.3 repository ==="
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update

echo "=== Installing PHP 8.3 and extensions ==="
sudo apt install -y \
  php8.3 php8.3-cli php8.3-fpm php8.3-mysql php8.3-mbstring \
  php8.3-xml php8.3-gd php8.3-curl php8.3-zip php8.3-bcmath \
  php8.3-tokenizer php8.3-sqlite3 nginx git unzip curl

echo "=== Setting PHP 8.3 as default ==="
sudo update-alternatives --set php /usr/bin/php8.3

echo "=== Installing Composer ==="
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

echo "=== PHP Version ==="
php -v

echo "=== Composer Version ==="
composer --version

echo "✅ Setup complete! PHP 8.3 is ready."
```

Save as `setup-php.sh`, make executable with `chmod +x setup-php.sh`, then run `./setup-php.sh`.

---

## ✅ Success Indicators

You'll know it's working when:

1. ✅ `php -v` shows **PHP 8.3.x** (not 8.1.x)
2. ✅ `sudo systemctl status php8.3-fpm` shows **active (running)**
3. ✅ `composer install` completes **without errors**
4. ✅ Nginx serves your Laravel app **without 502 errors**

---

## 📚 References

- **ondrej/php PPA**: [https://launchpad.net/~ondrej/+archive/ubuntu/php](https://launchpad.net/~ondrej/+archive/ubuntu/php)
- **Laravel Requirements**: PHP 8.2+ for Laravel 11.x
- **Ubuntu PHP Versions**: [https://packages.ubuntu.com/search?keywords=php](https://packages.ubuntu.com/search?keywords=php)

---

**Updated**: November 29, 2024  
**Applies to**: Ubuntu 22.04 LTS on AWS EC2  
**Status**: ✅ Tested and working
