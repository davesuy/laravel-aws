# 📋 Laravel AWS Deployment Checklist

Use this checklist to deploy your Laravel application to AWS Free Tier.

## Pre-Deployment ✓

- [ ] AWS Account created (https://aws.amazon.com)
- [ ] Logged into AWS Console (https://console.aws.amazon.com)
- [ ] Laravel project ready to deploy
- [ ] SSH client available (Terminal/PuTTY)

---

## Part 1: Create EC2 Key Pair

- [ ] Navigate to **EC2** service in AWS Console
- [ ] Click **"Key Pairs"** in left sidebar
- [ ] Click **"Create key pair"** button
- [ ] Enter name: `laravel-demo-key`
- [ ] Select type: **RSA**
- [ ] Select format: **.pem** (Mac/Linux) or **.ppk** (Windows)
- [ ] Click **"Create key pair"**
- [ ] File downloaded automatically
- [ ] Saved file to secure location
- [ ] Set permissions (Mac/Linux): `chmod 400 ~/Downloads/laravel-demo-key.pem`

**Key Pair Name**: `_____________________`

---

## Part 2: Deploy CloudFormation Stack

- [ ] Navigate to **CloudFormation** service
- [ ] Click **"Create stack"** button
- [ ] Select **"With new resources (standard)"**
- [ ] Choose **"Upload a template file"**
- [ ] Click **"Choose file"**
- [ ] Select `cloudformation-template.yaml` from project
- [ ] Click **"Next"**

### Stack Details
- [ ] Stack name entered: `laravel-demo`
- [ ] KeyPairName selected: `laravel-demo-key`
- [ ] AmiId: Default (Ubuntu 22.04)
- [ ] InstanceType: `t3.micro` (Free Tier)
- [ ] SSHLocation: Default or My IP
- [ ] Click **"Next"**

### Configure Options
- [ ] Left defaults as-is
- [ ] Click **"Next"**

### Review
- [ ] Checked box: "I acknowledge that AWS CloudFormation might create IAM resources"
- [ ] Click **"Submit"**

### Monitor Creation
- [ ] Stack status shows: `CREATE_IN_PROGRESS`
- [ ] Waited 5-10 minutes
- [ ] Status changed to: `CREATE_COMPLETE` ✅
- [ ] No errors in Events tab

---

## Part 3: Get Server Information

- [ ] Clicked on stack name
- [ ] Clicked **"Outputs"** tab
- [ ] Copied values:

**PublicIP**: `_____________________`

**PublicDNS**: `_____________________`

**WebsiteURL**: `_____________________`

**SSHCommand**: `_____________________`

---

## Part 4: Connect to Server

- [ ] Opened Terminal (Mac) or PuTTY (Windows)
- [ ] Connected via SSH:
  ```bash
  ssh -i ~/Downloads/laravel-demo-key.pem ubuntu@YOUR_PUBLIC_IP
  ```
- [ ] Typed `yes` to first-time connection prompt
- [ ] Successfully connected (Ubuntu terminal visible)

---

## Part 5: Deploy Laravel Application

Choose one method:

### Method A: Git Clone ✓
- [ ] Removed default directory:
  ```bash
  sudo rm -rf /var/www/laravel
  ```
- [ ] Cloned repository:
  ```bash
  sudo git clone https://github.com/yourusername/repo.git /var/www/laravel
  ```
- [ ] Repository cloned successfully

### Method B: SCP Upload ✓
- [ ] Created tarball on local machine:
  ```bash
  tar -czf laravel-app.tar.gz --exclude='vendor' --exclude='node_modules' .
  ```
- [ ] Uploaded to server:
  ```bash
  scp -i ~/Downloads/laravel-demo-key.pem laravel-app.tar.gz ubuntu@IP:~
  ```
- [ ] SSH'd back into server
- [ ] Extracted files:
  ```bash
  sudo mkdir -p /var/www/laravel
  sudo tar -xzf ~/laravel-app.tar.gz -C /var/www/laravel
  ```

---

## Part 6: Configure Environment

- [ ] Created/edited .env file:
  ```bash
  sudo nano /var/www/laravel/.env
  ```
- [ ] Set APP_URL to your public IP
- [ ] Configured database (SQLite or MySQL)
- [ ] Saved file (Ctrl+X, Y, Enter)

---

## Part 7: Run Deployment Script

- [ ] Ran deployment script:
  ```bash
  sudo /home/ubuntu/deploy-laravel.sh
  ```
- [ ] Script completed without errors
- [ ] Dependencies installed
- [ ] Assets built
- [ ] Migrations ran
- [ ] Permissions set
- [ ] Services restarted

---

## Part 8: Test Application

- [ ] Opened browser
- [ ] Visited: `http://YOUR_PUBLIC_IP`
- [ ] Laravel application loads successfully
- [ ] No errors visible
- [ ] Application working as expected

**🎉 SUCCESS!** Application is live!

---

## Post-Deployment (Security) ✓

### Restrict SSH Access
- [ ] Go to **EC2** → **Security Groups**
- [ ] Find `laravel-demo-SecurityGroup`
- [ ] Edit inbound rules
- [ ] Change SSH source from `0.0.0.0/0` to **"My IP"**
- [ ] Saved rules

### (Optional) Set Up SSL
- [ ] Domain name pointed to server IP
- [ ] Installed Certbot:
  ```bash
  sudo apt-get install -y certbot python3-certbot-nginx
  ```
- [ ] Obtained certificate:
  ```bash
  sudo certbot --nginx -d yourdomain.com
  ```
- [ ] HTTPS working

### (Optional) Secure MySQL
- [ ] Ran:
  ```bash
  sudo mysql_secure_installation
  ```
- [ ] Set root password
- [ ] Removed anonymous users
- [ ] Disabled remote root login

---

## Monitoring & Maintenance ✓

### View Logs
- [ ] Know how to check Nginx logs:
  ```bash
  sudo tail -f /var/log/nginx/error.log
  ```
- [ ] Know how to check Laravel logs:
  ```bash
  sudo tail -f /var/www/laravel/storage/logs/laravel.log
  ```

### Restart Services
- [ ] Know how to restart:
  ```bash
  sudo systemctl restart nginx
  sudo systemctl restart php8.1-fpm
  ```

### Update Code
- [ ] Know how to update:
  ```bash
  cd /var/www/laravel
  sudo git pull origin main
  sudo /home/ubuntu/deploy-laravel.sh
  ```

---

## Clean Up (When Done) ✓

### Delete Stack
- [ ] Go to **CloudFormation**
- [ ] Select stack: `laravel-demo`
- [ ] Click **"Delete"**
- [ ] Confirmed deletion
- [ ] Waited for `DELETE_COMPLETE`
- [ ] All resources deleted

### Delete Key Pair
- [ ] Go to **EC2** → **Key Pairs**
- [ ] Select `laravel-demo-key`
- [ ] Click **"Actions"** → **"Delete"**
- [ ] Confirmed deletion
- [ ] Deleted local .pem file

---

## 📊 Summary

**Deployment Date**: `_______________`

**Stack Name**: `_______________`

**Public IP**: `_______________`

**URL**: `_______________`

**Status**: ✅ Successfully Deployed

**Monthly Cost**: 
- First 12 months: **FREE** (AWS Free Tier)
- After Free Tier: **~$10/month**

---

## 🆘 If Something Went Wrong

Check these resources:
1. **AWS-CONSOLE-DEPLOYMENT.md** - Detailed guide
2. **CloudFormation Events tab** - Error messages
3. **Server logs** - Application errors
4. **Security Groups** - Network access

Common issues:
- Can't SSH → Check security group and key permissions
- Stack fails → Check Events tab for specific error
- Laravel 500 error → Check storage permissions
- Can't access website → Verify security group allows HTTP

---

**Congratulations!** 🎉 You've successfully deployed Laravel to AWS!

