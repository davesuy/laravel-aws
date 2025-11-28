# AWS CloudFormation Deployment Guide - Console Method

## Prerequisites

1. **AWS Account** (create at https://aws.amazon.com)
2. **Web Browser** (Chrome, Firefox, Safari, etc.)
3. **Your Laravel project** ready to upload

**Note**: This guide uses the AWS Console web interface. No command-line tools required!

## Quick Start

### 1. Create EC2 Key Pair

Before deploying, create a key pair for SSH access:

1. Log in to **AWS Console**: https://console.aws.amazon.com/
2. Navigate to **EC2** service (search for "EC2")
3. In left sidebar: **Network & Security** → **Key Pairs**
4. Click **"Create key pair"**
   - **Name**: `laravel-demo-key`
   - **Type**: RSA
   - **Format**: `.pem` (Mac/Linux) or `.ppk` (Windows)
5. Click **"Create key pair"** - file downloads automatically
6. **Save the file securely** (you can't download it again!)
7. On Mac/Linux, set permissions:
   ```bash
   chmod 400 ~/Downloads/laravel-demo-key.pem
   ```

### 2. Deploy the CloudFormation Stack

1. In AWS Console, search for **"CloudFormation"**
2. Click **"Create stack"** → **"With new resources (standard)"**
3. **Specify template**:
   - Choose **"Upload a template file"**
   - Click **"Choose file"** → Select `cloudformation-template.yaml`
   - Click **"Next"**
4. **Stack details**:
   - **Stack name**: `laravel-demo`
   - **KeyPairName**: Select `laravel-demo-key`
   - Leave other parameters as default
   - Click **"Next"**
5. **Configure options**: Click **"Next"** (leave defaults)
6. **Review**:
   - Check the box: ☑️ "I acknowledge that AWS CloudFormation might create IAM resources"
   - Click **"Submit"**

### 3. Monitor Stack Creation

1. You'll see stack status: `CREATE_IN_PROGRESS`
2. Click the refresh button (↻) periodically
3. Wait 5-10 minutes until status: **`CREATE_COMPLETE`** ✅

### 4. Get Stack Outputs

1. Click on your stack name (`laravel-demo`)
2. Click the **"Outputs"** tab
3. You'll see:
   - **PublicIP**: Your server's IP address
   - **WebsiteURL**: Direct link to your server
   - **SSHCommand**: Command to SSH into server

## What Gets Created

The CloudFormation template creates:

- ✅ **VPC** (10.0.0.0/16)
- ✅ **Public Subnet** (10.0.1.0/24)
- ✅ **Internet Gateway**
- ✅ **Route Tables** with proper routes
- ✅ **Security Group** (SSH, HTTP, HTTPS, Laravel dev server)
- ✅ **IAM Role & Instance Profile** (for SSM and CloudWatch)
- ✅ **t3.micro EC2 Instance** (Free Tier eligible)
- ✅ **30GB gp3 EBS Volume**

## Server Software Installed

The EC2 instance comes pre-configured with:

- Ubuntu 22.04 LTS
- Nginx web server
- PHP 8.1 (with required extensions)
- MySQL Server
- Composer
- Node.js 18.x & npm
- Git
- Supervisor

## Deploy Your Laravel Application

### Option 1: Using Git (Recommended)

1. SSH into your instance:
```bash
ssh -i ~/Downloads/laravel-demo-key.pem ubuntu@YOUR_PUBLIC_IP
```

2. Clone your repository:
```bash
sudo rm -rf /var/www/laravel
sudo git clone https://github.com/yourusername/your-repo.git /var/www/laravel
```

3. Run the deployment script:
```bash
sudo /home/ubuntu/deploy-laravel.sh
```

### Option 2: Using SCP

1. Create a tarball of your project:
```bash
cd /Users/davesuy/website-projects/laravel-aws
tar -czf laravel-app.tar.gz \
  --exclude='vendor' \
  --exclude='node_modules' \
  --exclude='.git' \
  --exclude='storage/logs/*' \
  .
```

2. Copy to server:
```bash
scp -i ~/Downloads/laravel-demo-key.pem laravel-app.tar.gz ubuntu@YOUR_IP:~
```

3. SSH and extract:
```bash
ssh -i ~/Downloads/laravel-demo-key.pem ubuntu@YOUR_IP
sudo mkdir -p /var/www/laravel
sudo tar -xzf laravel-app.tar.gz -C /var/www/laravel
sudo /home/ubuntu/deploy-laravel.sh
```

### Option 3: Manual Setup

1. SSH into the instance
2. Copy your files to `/var/www/laravel`
3. Create `.env` file:
```bash
cd /var/www/laravel
sudo cp .env.example .env
sudo nano .env
```

4. Update `.env` with your settings:
```env
APP_NAME=LaravelDemo
APP_ENV=production
APP_KEY=
APP_DEBUG=false
APP_URL=http://your-public-ip

DB_CONNECTION=sqlite
# or use MySQL:
# DB_CONNECTION=mysql
# DB_HOST=127.0.0.1
# DB_PORT=3306
# DB_DATABASE=laravel
# DB_USERNAME=root
# DB_PASSWORD=
```

5. Run deployment:
```bash
sudo /home/ubuntu/deploy-laravel.sh
```

## Access Your Application

Get your public IP from the CloudFormation **Outputs** tab, then open in browser:

`http://YOUR_PUBLIC_IP`

## Security Best Practices

### 1. Restrict SSH Access

To allow SSH only from your IP:

1. Go to **EC2** → **Security Groups** in AWS Console
2. Find `laravel-demo-SecurityGroup`
3. Click **"Edit inbound rules"**
4. Find SSH (port 22) rule
5. Change Source from `0.0.0.0/0` to **"My IP"**
6. Click **"Save rules"**

### 2. Set Up HTTPS (Optional)

Install Let's Encrypt SSL certificate:
```bash
ssh -i laravel-demo-key.pem ubuntu@$PUBLIC_IP

sudo apt-get install -y certbot python3-certbot-nginx
sudo certbot --nginx -d yourdomain.com
```

### 3. Secure Your Database

```bash
sudo mysql_secure_installation
```

## Monitoring & Logs

### View Nginx Logs
```bash
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log
```

### View Laravel Logs
```bash
sudo tail -f /var/www/laravel/storage/logs/laravel.log
```

### View PHP-FPM Logs
```bash
sudo tail -f /var/log/php8.1-fpm.log
```

## Troubleshooting

### Check Service Status
```bash
sudo systemctl status nginx
sudo systemctl status php8.1-fpm
sudo systemctl status mysql
```

### Restart Services
```bash
sudo systemctl restart nginx
sudo systemctl restart php8.1-fpm
```

### Fix Permissions
```bash
sudo chown -R www-data:www-data /var/www/laravel
sudo chmod -R 755 /var/www/laravel
sudo chmod -R 775 /var/www/laravel/storage
sudo chmod -R 775 /var/www/laravel/bootstrap/cache
```

### Check Nginx Configuration
```bash
sudo nginx -t
```

## Stack Management

### Update Stack

1. Go to **CloudFormation** in AWS Console
2. Select your stack (`laravel-demo`)
3. Click **"Update"**
4. Choose **"Use current template"** or upload new one
5. Follow the wizard and click **"Submit"**

### Delete Stack

1. Go to **CloudFormation** in AWS Console
2. Select your stack (`laravel-demo`)
3. Click **"Delete"**
4. Confirm deletion
5. Wait for `DELETE_COMPLETE` status

### View Stack Events

1. Click on your stack name
2. Click the **"Events"** tab
3. See all creation/update/deletion events

## Cost Optimization

This template uses Free Tier eligible resources:
- **t3.micro instance**: 750 hours/month free (first 12 months)
- **30GB EBS storage**: 30GB free (first 12 months)
- **Data transfer**: 15GB out/month free

⚠️ **Remember to delete the stack when done to avoid charges!**

## Additional Resources

- [Laravel Documentation](https://laravel.com/docs)
- [AWS CloudFormation Documentation](https://docs.aws.amazon.com/cloudformation/)
- [EC2 Free Tier Details](https://aws.amazon.com/ec2/pricing/)

## Support

For issues or questions:
1. Check CloudFormation events for error messages
2. SSH into instance and check logs
3. Verify security group rules
4. Ensure your key pair is correct

