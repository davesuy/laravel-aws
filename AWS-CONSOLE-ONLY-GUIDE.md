# 🚀 Laravel AWS Deployment - AWS Console Only Guide

**Last Updated:** November 28, 2025  
**Deployment Method:** AWS Console Web Interface (No CLI Required)

---

## ✅ CloudFormation Template Status

Your `cloudformation-template.yaml` is **100% READY FOR DEPLOYMENT!**

### Validation Results:
- ✅ Valid YAML syntax
- ✅ All 11 resources properly configured
- ✅ Free Tier optimized (t3.micro)
- ✅ Complete VPC networking setup
- ✅ Security groups configured
- ✅ IAM roles with least privilege
- ✅ UserData script for automated setup
- ✅ No errors found

**Full validation report:** [TEMPLATE-VALIDATION-REPORT.md](./TEMPLATE-VALIDATION-REPORT.md)

---

## 📋 What You're Deploying

### Infrastructure Components:
1. **VPC** (10.0.0.0/16) with DNS enabled
2. **Public Subnet** (10.0.1.0/24) with auto-assign public IP
3. **Internet Gateway** for public internet access
4. **Route Tables** configured for internet routing
5. **Security Group** with ports:
   - 22 (SSH)
   - 80 (HTTP)
   - 443 (HTTPS)
   - 8000 (Laravel dev server)
6. **IAM Role** with SSM and CloudWatch permissions
7. **EC2 Instance** (t3.micro) with Ubuntu 22.04 LTS

### Pre-installed Software:
- ✅ Nginx web server
- ✅ PHP 8.1 with all Laravel extensions
- ✅ MySQL Server
- ✅ Composer
- ✅ Node.js 18
- ✅ Git
- ✅ Supervisor

### Cost:
- **Free Tier:** $0/month for first 12 months
- **After Free Tier:** ~$10/month

---

## 🎯 Deployment Steps

### Prerequisites:
1. ✅ AWS Account (https://aws.amazon.com)
2. ✅ Web browser
3. ✅ SSH client (Terminal/PuTTY)
4. ✅ Your Laravel project code

### Step 1: Create EC2 Key Pair

1. Log in to [AWS Console](https://console.aws.amazon.com/)
2. Search for "EC2" in the top search bar
3. Click **"Key Pairs"** in the left sidebar (under Network & Security)
4. Click **"Create key pair"** button
5. Configure:
   - **Name:** `laravel-demo-key` (or your preferred name)
   - **Key pair type:** RSA
   - **Private key file format:** 
     - `.pem` for Mac/Linux
     - `.ppk` for Windows (PuTTY)
6. Click **"Create key pair"**
7. Save the downloaded file securely
8. Set permissions (Mac/Linux only):
   ```bash
   chmod 400 ~/Downloads/laravel-demo-key.pem
   ```

✅ **Key pair created!**

---

### Step 2: Deploy CloudFormation Stack

1. **Navigate to CloudFormation:**
   - Search for "CloudFormation" in AWS Console
   - Click on CloudFormation service

2. **Create Stack:**
   - Click **"Create stack"** → **"With new resources (standard)"**

3. **Upload Template:**
   - Select **"Upload a template file"**
   - Click **"Choose file"**
   - Select `cloudformation-template.yaml` from your project
   - Click **"Next"**

4. **Configure Stack:**
   - **Stack name:** `laravel-demo` (or your preferred name)
   - **Parameters:**
     - **AmiId:** Leave default (`ami-01fd6fa49060e89a6`)
       - ⚠️ This is for `us-east-1` region only
       - For other regions, update AMI ID (see below)
     - **KeyPairName:** Select your key pair from dropdown
     - **InstanceType:** Leave default (`t3.micro`)
     - **SSHLocation:** Leave default (`0.0.0.0/0`) or enter your IP
   - Click **"Next"**

5. **Configure Options:**
   - Leave all defaults
   - (Optional) Add tags for organization
   - Click **"Next"**

6. **Review:**
   - Scroll to bottom
   - ☑️ Check: **"I acknowledge that AWS CloudFormation might create IAM resources with custom names."**
   - Click **"Submit"**

7. **Monitor Progress:**
   - Status will show: `CREATE_IN_PROGRESS`
   - Click refresh (↻) button periodically
   - Wait 5-10 minutes
   - Status changes to: **`CREATE_COMPLETE`** ✅

8. **Get Server Information:**
   - Click the **"Outputs"** tab
   - Copy these values:
     - **PublicIP** - Your server's IP address
     - **WebsiteURL** - Direct link to server
     - **SSHCommand** - SSH connection command

✅ **Stack deployed!**

---

### Step 3: Connect to Your Server

**Mac/Linux:**
```bash
ssh -i ~/Downloads/laravel-demo-key.pem ubuntu@YOUR_PUBLIC_IP
```

**Windows (PowerShell):**
```powershell
ssh -i ~/Downloads/laravel-demo-key.pem ubuntu@YOUR_PUBLIC_IP
```

**Windows (PuTTY):**
- Host: YOUR_PUBLIC_IP
- Port: 22
- Connection → SSH → Auth → Browse → Select your `.ppk` file
- Username: ubuntu

**First connection:**
- Type `yes` when asked "Are you sure you want to continue connecting?"

✅ **Connected!**

---

### Step 4: Deploy Laravel Application

You have 3 options:

#### Option A: Clone from Git (Recommended)

```bash
# Remove default directory
sudo rm -rf /var/www/laravel

# Clone your repository
sudo git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git /var/www/laravel

# Run deployment script
sudo /home/ubuntu/deploy-laravel.sh
```

#### Option B: Upload via SCP

**On your local machine:**
```bash
# Navigate to your Laravel project
cd /Users/davesuy/website-projects/laravel-aws

# Create tarball (excluding vendor and node_modules)
tar -czf laravel-app.tar.gz \
  --exclude='vendor' \
  --exclude='node_modules' \
  --exclude='.git' \
  --exclude='storage/logs/*' \
  .

# Upload to server
scp -i ~/Downloads/laravel-demo-key.pem laravel-app.tar.gz ubuntu@YOUR_IP:~
```

**Then SSH in and extract:**
```bash
# SSH to server
ssh -i ~/Downloads/laravel-demo-key.pem ubuntu@YOUR_IP

# Extract and deploy
sudo rm -rf /var/www/laravel
sudo mkdir -p /var/www/laravel
sudo tar -xzf ~/laravel-app.tar.gz -C /var/www/laravel
sudo /home/ubuntu/deploy-laravel.sh
```

#### Option C: Use SFTP Client (FileZilla/Cyberduck)

1. **Connect:**
   - Protocol: SFTP
   - Host: YOUR_PUBLIC_IP
   - Username: ubuntu
   - Key file: Your `.pem` file
   - Port: 22

2. **Upload files** to `/home/ubuntu/laravel-app`

3. **SSH in and move:**
   ```bash
   sudo cp -r ~/laravel-app/* /var/www/laravel/
   sudo /home/ubuntu/deploy-laravel.sh
   ```

✅ **Laravel deployed!**

---

### Step 5: Configure Environment

```bash
# SSH to server
ssh -i ~/Downloads/laravel-demo-key.pem ubuntu@YOUR_IP

# Copy environment file
sudo cp /var/www/laravel/.env.example /var/www/laravel/.env

# Edit environment (using nano or vi)
sudo nano /var/www/laravel/.env
```

**Update these values:**
```env
APP_NAME="Your App Name"
APP_ENV=production
APP_DEBUG=false
APP_URL=http://YOUR_PUBLIC_IP

DB_CONNECTION=sqlite
# OR for MySQL:
# DB_CONNECTION=mysql
# DB_HOST=127.0.0.1
# DB_PORT=3306
# DB_DATABASE=laravel
# DB_USERNAME=laravel
# DB_PASSWORD=your_secure_password
```

**Save and run deployment:**
```bash
sudo /home/ubuntu/deploy-laravel.sh
```

---

### Step 6: Test Your Application

Visit: **`http://YOUR_PUBLIC_IP`**

You should see:
- ✅ Laravel welcome page (if fresh install)
- ✅ Your Laravel application (if deployed)

---

## 🔐 Post-Deployment Security

### 1. Restrict SSH Access

**Via AWS Console:**
1. Go to **EC2** → **Security Groups**
2. Find: `[your-stack-name]-SecurityGroup`
3. Click **"Edit inbound rules"**
4. Find SSH rule (port 22)
5. Change from `0.0.0.0/0` to `YOUR_IP/32`
6. Get your IP: https://whatismyipaddress.com/
7. Click **"Save rules"**

### 2. Configure MySQL (if using)

```bash
# SSH to server
ssh -i ~/Downloads/laravel-demo-key.pem ubuntu@YOUR_IP

# Run MySQL secure installation
sudo mysql_secure_installation

# Create Laravel database
sudo mysql -u root -p
```

```sql
CREATE DATABASE laravel;
CREATE USER 'laravel'@'localhost' IDENTIFIED BY 'secure_password_here';
GRANT ALL PRIVILEGES ON laravel.* TO 'laravel'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### 3. Setup SSL (Optional - for custom domain)

```bash
# Install Certbot
sudo apt-get install -y certbot python3-certbot-nginx

# Get SSL certificate
sudo certbot --nginx -d yourdomain.com
```

---

## 🐛 Troubleshooting

### Stack Creation Failed

**Check the Events tab:**
1. Go to **CloudFormation** → Your Stack
2. Click **"Events"** tab
3. Look for `CREATE_FAILED` status
4. Read "Status reason" for details

**Common Issues:**
- ❌ Missing IAM acknowledgment checkbox → Check the box and retry
- ❌ Key pair doesn't exist → Create key pair first
- ❌ AMI not available → You're in wrong region or AMI changed
- ❌ Service limits reached → Request limit increase

### Can't SSH to Server

**Check list:**
- ✅ Key file permissions: `chmod 400 your-key.pem`
- ✅ Using correct username: `ubuntu` (not `ec2-user`)
- ✅ Using correct IP from Outputs tab
- ✅ Security group allows your IP
- ✅ Instance is running (EC2 → Instances)

**Test security group:**
```bash
# Test if port 22 is accessible
telnet YOUR_IP 22
# OR
nc -zv YOUR_IP 22
```

### Laravel Shows Errors

**Check logs:**
```bash
# Nginx error log
sudo tail -f /var/log/nginx/error.log

# Nginx access log
sudo tail -f /var/log/nginx/access.log

# Laravel log
sudo tail -f /var/www/laravel/storage/logs/laravel.log

# Cloud-init log (UserData script)
sudo tail -f /var/log/cloud-init-output.log
```

**Fix permissions:**
```bash
sudo chown -R www-data:www-data /var/www/laravel
sudo chmod -R 755 /var/www/laravel
sudo chmod -R 775 /var/www/laravel/storage
sudo chmod -R 775 /var/www/laravel/bootstrap/cache
```

**Clear Laravel cache:**
```bash
cd /var/www/laravel
sudo php artisan cache:clear
sudo php artisan config:clear
sudo php artisan route:clear
sudo php artisan view:clear
```

### UserData Script Still Running

The stack may show `CREATE_COMPLETE` but UserData takes 5-10 minutes extra.

**Check status:**
```bash
# SSH to server
ssh -i ~/Downloads/laravel-demo-key.pem ubuntu@YOUR_IP

# Check if cloud-init finished
sudo cloud-init status

# Watch the log
sudo tail -f /var/log/cloud-init-output.log
```

---

## 🗑️ Cleanup (Delete Resources)

**To avoid charges, delete the stack when done:**

1. Go to **CloudFormation** → Stacks
2. Select your stack
3. Click **"Delete"**
4. Confirm deletion
5. Wait for `DELETE_COMPLETE`

**Note:** This deletes ALL resources (EC2, VPC, Security Groups, etc.)

---

## 📊 AMI IDs by Region

If deploying outside `us-east-1`, use these Ubuntu 22.04 LTS AMI IDs:

| Region         | AMI ID                  | Name              |
|----------------|-------------------------|-------------------|
| us-east-1      | ami-01fd6fa49060e89a6    | N. Virginia       |
| us-east-2      | ami-0a0d9cf81c479446a    | Ohio              |
| us-west-1      | ami-0cbd87452f6f5bfb5    | N. California     |
| us-west-2      | ami-0cf2b4e024cdb6960    | Oregon            |
| eu-west-1      | ami-01dd271720c1ba44f    | Ireland           |
| eu-west-2      | ami-0b9932f4918a00c4f    | London            |
| eu-central-1   | ami-06ce824c157700cd2    | Frankfurt         |
| ap-southeast-1 | ami-0dc2d3e4c0f9ebd18    | Singapore         |
| ap-southeast-2 | ami-0375ab65ee943a2a6    | Sydney            |
| ap-northeast-1 | ami-0e0c2f8f3e5f5e8e9    | Tokyo             |

**How to find AMI:**
1. Go to **EC2** → **Launch Instance**
2. Search for "Ubuntu 22.04 LTS"
3. Copy the AMI ID
4. Use it in CloudFormation parameters

---

## 📚 Documentation Reference

- **[AWS-CONSOLE-DEPLOYMENT.md](./AWS-CONSOLE-DEPLOYMENT.md)** - Detailed step-by-step guide
- **[TEMPLATE-VALIDATION-REPORT.md](./TEMPLATE-VALIDATION-REPORT.md)** - Template validation details
- **[GETTING-STARTED.md](./GETTING-STARTED.md)** - Quick start overview
- **[START-HERE.md](./START-HERE.md)** - Quick reference
- **[README.md](./README.md)** - Project overview

---

## ✅ Success Checklist

- [ ] AWS account created
- [ ] EC2 key pair created and saved
- [ ] CloudFormation stack deployed successfully
- [ ] Stack shows `CREATE_COMPLETE` status
- [ ] Server IP obtained from Outputs tab
- [ ] SSH connection successful
- [ ] Laravel code deployed to `/var/www/laravel`
- [ ] Deployment script executed
- [ ] Website accessible at `http://YOUR_IP`
- [ ] SSH access restricted to your IP
- [ ] Environment file configured

---

## 🎉 You're Done!

Your Laravel application is now running on AWS Free Tier!

**Next steps:**
- Point your domain to the server IP
- Set up SSL with Let's Encrypt
- Configure database backups
- Set up monitoring

**Questions or issues?**
- Check the troubleshooting section above
- Review the detailed guides in the documentation
- Check AWS CloudFormation Events tab for errors

---

**Deployed:** Ready to deploy  
**Template:** ✅ Validated and ready  
**Method:** AWS Console only (no CLI required)  
**Cost:** $0 with Free Tier for 12 months

