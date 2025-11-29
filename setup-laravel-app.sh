#!/bin/bash

# Laravel Application Deployment Helper
# Run this script AFTER CloudFormation stack is created
# This script should be executed on the EC2 instance

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ $1${NC}"; }

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Laravel Application Setup${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Check if running as root or with sudo
if [ "$EUID" -eq 0 ]; then
    print_error "Please do not run this script as root"
    exit 1
fi

APP_DIR="/var/www/laravel"
NGINX_USER="nginx"

# Check if we're on the EC2 instance
if [ ! -d "$APP_DIR" ]; then
    print_error "Application directory not found. Are you on the EC2 instance?"
    exit 1
fi

cd $APP_DIR

# Option 1: Clone from Git Repository
echo -e "\n${BLUE}How would you like to deploy your application?${NC}"
echo "1. Clone from Git repository"
echo "2. Upload files manually (you'll need to use SCP)"
read -p "Select option (1-2): " DEPLOY_OPTION

if [ "$DEPLOY_OPTION" == "1" ]; then
    read -p "Enter your Git repository URL: " GIT_REPO

    if [ -z "$GIT_REPO" ]; then
        print_error "Git repository URL is required"
        exit 1
    fi

    print_info "Cloning repository..."

    # Check if directory has files
    if [ "$(ls -A $APP_DIR)" ]; then
        print_warning "Application directory is not empty"
        read -p "Clear directory and clone? (y/n): " CLEAR_DIR
        if [ "$CLEAR_DIR" == "y" ]; then
            sudo rm -rf $APP_DIR/*
            sudo rm -rf $APP_DIR/.*  2>/dev/null || true
        else
            print_error "Cannot proceed with existing files"
            exit 1
        fi
    fi

    # Clone repository
    sudo -u $NGINX_USER git clone "$GIT_REPO" $APP_DIR/temp
    sudo -u $NGINX_USER mv $APP_DIR/temp/* $APP_DIR/
    sudo -u $NGINX_USER mv $APP_DIR/temp/.* $APP_DIR/ 2>/dev/null || true
    sudo rm -rf $APP_DIR/temp

    print_success "Repository cloned"

elif [ "$DEPLOY_OPTION" == "2" ]; then
    print_info "Please upload your files using SCP from your local machine:"
    echo ""
    echo "From your local machine, run:"
    echo "  cd /Users/davesuy/website-projects/laravel-aws"
    echo "  scp -i ~/Desktop/Web\\ Development/laravel-demo-key.pem -r ./* ec2-user@\$(PUBLIC_IP):/tmp/laravel-files"
    echo ""
    read -p "Press Enter after you've uploaded the files..."

    if [ ! -d "/tmp/laravel-files" ]; then
        print_error "Files not found in /tmp/laravel-files"
        exit 1
    fi

    # Move files to app directory
    sudo rm -rf $APP_DIR/*
    sudo mv /tmp/laravel-files/* $APP_DIR/
    sudo mv /tmp/laravel-files/.* $APP_DIR/ 2>/dev/null || true
    sudo rm -rf /tmp/laravel-files

    print_success "Files uploaded"
else
    print_error "Invalid option"
    exit 1
fi

# Restore .env file if it was overwritten
if [ ! -f "$APP_DIR/.env" ] || [ ! -s "$APP_DIR/.env" ]; then
    print_warning ".env file not found or empty, keeping the generated one"
fi

# Set ownership
print_info "Setting file permissions..."
sudo chown -R $NGINX_USER:$NGINX_USER $APP_DIR
sudo chmod -R 755 $APP_DIR
sudo chmod -R 775 $APP_DIR/storage
sudo chmod -R 775 $APP_DIR/bootstrap/cache 2>/dev/null || sudo mkdir -p $APP_DIR/bootstrap/cache && sudo chmod -R 775 $APP_DIR/bootstrap/cache
print_success "Permissions set"

# Install Composer dependencies
print_info "Installing Composer dependencies..."
cd $APP_DIR
sudo -u $NGINX_USER composer install --no-dev --optimize-autoloader --no-interaction
print_success "Composer dependencies installed"

# Generate application key if not exists
if ! grep -q "APP_KEY=base64:" $APP_DIR/.env; then
    print_info "Generating application key..."
    sudo -u $NGINX_USER php artisan key:generate --force
    print_success "Application key generated"
fi

# Run database migrations
print_info "Running database migrations..."
read -p "Run migrations now? (y/n): " RUN_MIGRATIONS
if [ "$RUN_MIGRATIONS" == "y" ]; then
    sudo -u $NGINX_USER php artisan migrate --force
    print_success "Migrations completed"

    # Ask about seeding
    read -p "Run database seeders? (y/n): " RUN_SEEDERS
    if [ "$RUN_SEEDERS" == "y" ]; then
        sudo -u $NGINX_USER php artisan db:seed --force
        print_success "Database seeded"
    fi
fi

# Install and build frontend assets
if [ -f "$APP_DIR/package.json" ]; then
    print_info "Installing Node.js dependencies..."
    sudo -u $NGINX_USER npm install
    print_success "Node.js dependencies installed"

    print_info "Building frontend assets..."
    sudo -u $NGINX_USER npm run build
    print_success "Frontend assets built"
fi

# Cache configuration
print_info "Caching configuration..."
sudo -u $NGINX_USER php artisan config:cache
sudo -u $NGINX_USER php artisan route:cache
sudo -u $NGINX_USER php artisan view:cache
print_success "Configuration cached"

# Create storage link
print_info "Creating storage link..."
sudo -u $NGINX_USER php artisan storage:link 2>/dev/null || print_warning "Storage link already exists"

# Install AWS S3 package if needed
if grep -q "FILESYSTEM_DISK=s3" $APP_DIR/.env; then
    print_info "Installing AWS S3 package..."
    sudo -u $NGINX_USER composer require league/flysystem-aws-s3-v3 "^3.0" --no-interaction
    print_success "AWS S3 package installed"
fi

# Restart services
print_info "Restarting services..."
sudo systemctl restart php-fpm
sudo systemctl restart nginx
print_success "Services restarted"

# Test application
print_info "Testing application..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost)
if [ "$HTTP_CODE" == "200" ]; then
    print_success "Application is responding (HTTP $HTTP_CODE)"
else
    print_warning "Application returned HTTP $HTTP_CODE"
fi

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}Application Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}\n"

print_info "Your Laravel application is now deployed"
print_info "You can access it at the public IP or domain"
echo ""
print_warning "Recommended next steps:"
echo "1. Set up SSL certificate with Let's Encrypt (see DEPLOYMENT.md)"
echo "2. Configure your domain name"
echo "3. Set up monitoring and logging"
echo "4. Review security settings"
echo "5. Set up automated backups"
echo ""
print_success "Deployment complete!"

