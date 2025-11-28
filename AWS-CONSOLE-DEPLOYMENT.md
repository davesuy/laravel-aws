# 🚀 Deploy Laravel to AWS (Free Tier) - Using AWS Console

Complete step-by-step guide to deploy your Laravel application to AWS using the web console (no CLI needed).

## 📋 Prerequisites

1. **AWS Account** (create one at https://aws.amazon.com if you don't have it)
2. **Your Laravel project files** ready to upload
3. **10-15 minutes** of your time

---

## Part 1: Create EC2 Key Pair

Before deploying the CloudFormation stack, you need to create an EC2 Key Pair for SSH access.

### Steps:

1. **Log in to AWS Console**: https://console.aws.amazon.com/

2. **Navigate to EC2 Service**:
   - Use the search bar at the top
   - Type "EC2" and click on the service

3. **Go to Key Pairs**:
   - In the left sidebar, scroll down to "Network & Security"
   - Click on **"Key Pairs"**

4. **Create Key Pair**:
   - Click the orange **"Create key pair"** button
   - **Name**: `laravel-demo-key` (or any name you prefer)
   - **Key pair type**: RSA
   - **Private key file format**: `.pem` (for Mac/Linux) or `.ppk` (for Windows)
   - Click **"Create key pair"**

5. **Save the file**:
   - The `.pem` file will automatically download
   - **IMPORTANT**: Save this file securely! You can't download it again
   - On Mac, move it to a safe location and run:
     ```bash
     chmod 400 ~/Downloads/laravel-demo-key.pem
     ```

✅ **Key Pair Created!** Remember the name - you'll need it in the next step.

---

## Part 2: Deploy CloudFormation Stack

Now let's deploy the infrastructure using CloudFormation.

### Steps:

1. **Navigate to CloudFormation Service**:
   - In AWS Console, search for "CloudFormation"
   - Click on the **CloudFormation** service

2. **Create Stack**:
   - Click the orange **"Create stack"** button
   - Select **"With new resources (standard)"**

3. **Specify Template**:
   - Choose **"Upload a template file"**
   - Click **"Choose file"**
   - Select the `cloudformation-template.yaml` file from your project
   - Click **"Next"**

4. **Specify Stack Details**:
   - **Stack name**: `laravel-demo` (or any name you prefer)
   - **Parameters**:
     - **AmiId**: Leave default (`ami-01fd6fa49060e89a6` - Ubuntu 22.04)
     - **KeyPairName**: Select the key pair you created (`laravel-demo-key`)
     - **InstanceType**: Leave default (`t3.micro` - Free Tier)
     - **SSHLocation**: Leave default (`0.0.0.0/0`) or enter your IP for security
   - Click **"Next"**

5. **Configure Stack Options**:
   - Leave everything as default
   - (Optional) Add tags if you want
   - Click **"Next"**

6. **Review**:
   - Scroll down and check the box:
     - ☑️ **"I acknowledge that AWS CloudFormation might create IAM resources with custom names."**
   - Click **"Submit"**

7. **Wait for Completion** (5-10 minutes):
   - You'll see the stack status: `CREATE_IN_PROGRESS`
   - Click the refresh button (↻) periodically
   - Wait until status changes to: **`CREATE_COMPLETE`** ✅

8. **Get Your Server Information**:
   - Click on the **"Outputs"** tab
   - You'll see important information:
     - **PublicIP**: Your server's IP address (e.g., 54.123.45.67)
     - **PublicDNS**: Your server's DNS name
     - **WebsiteURL**: Direct link to your server
     - **SSHCommand**: Command to connect via SSH

✅ **Stack Deployed!** Your server is now running.

---

## Part 3: Connect to Your Server

Now let's SSH into your server to deploy your Laravel application.

### On Mac/Linux:

```bash
# Navigate to where you saved your key
cd ~/Downloads  # or wherever you saved it

# Connect to your server (replace with your IP from Outputs)
ssh -i laravel-demo-key.pem ubuntu@YOUR_PUBLIC_IP
```

### On Windows:

Use **PuTTY** or **Windows Terminal**:

```powershell
ssh -i laravel-demo-key.pem ubuntu@YOUR_PUBLIC_IP
```

### First Time Connection:

- You'll see: "Are you sure you want to continue connecting?"
- Type: `yes` and press Enter

✅ **Connected!** You should now see the Ubuntu terminal.

---

## Part 4: Deploy Your Laravel Application

You have three options to get your Laravel code onto the server:

### Option A: Clone from Git (Recommended)

If your code is in a Git repository:

```bash
# Remove the default directory
sudo rm -rf /var/www/laravel

# Clone your repository
sudo git clone https://github.com/yourusername/your-repo.git /var/www/laravel

# Run the deployment script
sudo /home/ubuntu/deploy-laravel.sh
```

### Option B: Upload via SCP

From your **local machine** (not on the server):

```bash
# Create a tarball of your project
cd /Users/davesuy/website-projects/laravel-aws
tar -czf laravel-app.tar.gz \
  --exclude='vendor' \
  --exclude='node_modules' \
  --exclude='.git' \
  --exclude='storage/logs/*' \
  .

# Upload to server (replace with your IP)
scp -i ~/Downloads/laravel-demo-key.pem laravel-app.tar.gz ubuntu@YOUR_IP:~

# SSH back into server
ssh -i ~/Downloads/laravel-demo-key.pem ubuntu@YOUR_IP

# Extract and deploy
sudo mkdir -p /var/www/laravel
sudo tar -xzf ~/laravel-app.tar.gz -C /var/www/laravel
sudo /home/ubuntu/deploy-laravel.sh
```

### Option C: Use SFTP Client

Use a GUI tool like **FileZilla** or **Cyberduck**:

1. Connect using:
   - **Protocol**: SFTP
   - **Host**: Your public IP
   - **Username**: ubuntu
   - **Key file**: Your `.pem` file
2. Upload your Laravel files to `/home/ubuntu/laravel-app`
3. SSH in and run:
   ```bash
   sudo cp -r ~/laravel-app/* /var/www/laravel/
   sudo /home/ubuntu/deploy-laravel.sh
   ```

---

## Part 5: Configure Laravel Environment

After deploying your code, configure the environment:

```bash
# Edit the .env file
sudo nano /var/www/laravel/.env
```

**Minimal configuration for demo**:

```env
APP_NAME="Laravel Demo"
APP_ENV=production
APP_KEY=base64:XXXXX  # This will be generated
APP_DEBUG=false
APP_URL=http://YOUR_PUBLIC_IP

# Use SQLite for simplicity (no MySQL config needed)
DB_CONNECTION=sqlite

# Or use MySQL
# DB_CONNECTION=mysql
# DB_HOST=127.0.0.1
# DB_PORT=3306
# DB_DATABASE=laravel
# DB_USERNAME=root
# DB_PASSWORD=your-password
```

**Save the file**: Press `Ctrl+X`, then `Y`, then `Enter`

---

## Part 6: Run Deployment Script

The server has a pre-configured deployment script:

```bash
sudo /home/ubuntu/deploy-laravel.sh
```

This script will:
- ✅ Install Composer dependencies
- ✅ Install NPM dependencies and build assets
- ✅ Generate application key
- ✅ Run database migrations
- ✅ Cache configuration
- ✅ Set proper permissions
- ✅ Restart web server

---

## Part 7: Access Your Application

Open your browser and go to:

```
http://YOUR_PUBLIC_IP
```

You should see your Laravel application! 🎉

---

## 📊 What You Have

Your AWS infrastructure includes:

✅ **VPC** (Virtual Private Cloud)
✅ **Public Subnet** with Internet Gateway
✅ **Security Groups** (SSH, HTTP, HTTPS)
✅ **t3.micro EC2 Instance** (Free Tier eligible)
✅ **Ubuntu 22.04 LTS** with:
  - Nginx web server
  - PHP 8.1 (all extensions)
  - MySQL Server
  - Composer
  - Node.js 18.x & npm
  - Git
  - Supervisor
✅ **30GB SSD Storage**

---

## 🔒 Security Best Practices

### 1. Restrict SSH Access

To allow SSH only from your IP:

1. Go to **EC2** → **Security Groups**
2. Find the security group named `laravel-demo-SecurityGroup`
3. Click **"Edit inbound rules"**
4. Find the SSH rule (port 22)
5. Change source from `0.0.0.0/0` to `My IP`
6. Click **"Save rules"**

### 2. Set Up HTTPS (Optional)

If you have a domain name:

```bash
# Install Certbot
sudo apt-get update
sudo apt-get install -y certbot python3-certbot-nginx

# Get SSL certificate
sudo certbot --nginx -d yourdomain.com

# Auto-renewal is configured automatically
```

### 3. Secure MySQL

```bash
sudo mysql_secure_installation
```

---

## 🛠️ Common Tasks

### View Logs

```bash
# Nginx error log
sudo tail -f /var/log/nginx/error.log

# Laravel log
sudo tail -f /var/www/laravel/storage/logs/laravel.log

# PHP-FPM log
sudo tail -f /var/log/php8.1-fpm.log
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

### Update Your Code

```bash
cd /var/www/laravel
sudo git pull origin main
sudo /home/ubuntu/deploy-laravel.sh
```

---

## 🗑️ Clean Up (Delete Everything)

When you're done testing and want to avoid charges:

1. Go to **CloudFormation** in AWS Console
2. Select your stack (`laravel-demo`)
3. Click **"Delete"**
4. Confirm deletion
5. Wait for `DELETE_COMPLETE` status

This will delete:
- ✅ EC2 instance
- ✅ Security groups
- ✅ VPC and networking
- ✅ IAM roles
- ✅ All associated resources

**Note**: This does NOT delete your Key Pair. To delete that:
1. Go to **EC2** → **Key Pairs**
2. Select your key pair
3. Click **"Actions"** → **"Delete"**

---

## 💰 Cost Information

**With AWS Free Tier** (first 12 months):
- ✅ 750 hours/month of t3.micro (FREE)
- ✅ 30GB storage (FREE)
- ✅ 15GB data transfer out (FREE)

**After Free Tier**:
- t3.micro instance: ~$7.50/month
- 30GB storage: ~$2.40/month
- Data transfer: Usually minimal
- **Total**: ~$10/month

💡 **Tip**: Delete the stack when not in use to avoid charges!

---

## 🐛 Troubleshooting

### Stack Creation Failed

1. Go to **CloudFormation** → Your stack
2. Click **"Events"** tab
3. Look for events with status `CREATE_FAILED`
4. Check the "Status reason" for details

**Common issues**:
- Key pair doesn't exist → Create the key pair first
- AMI not available in region → Check your region matches the AMI
- Limit exceeded → Check your EC2 instance limits

### Can't SSH to Server

**Check**:
- ✅ Key file permissions: `chmod 400 laravel-demo-key.pem`
- ✅ Using correct IP address from Outputs tab
- ✅ Using correct key file
- ✅ Security group allows your IP on port 22

**Try**:
```bash
ssh -vvv -i laravel-demo-key.pem ubuntu@YOUR_IP
```

### Laravel Not Loading

**Check**:
1. Nginx is running: `sudo systemctl status nginx`
2. PHP-FPM is running: `sudo systemctl status php8.1-fpm`
3. Files are in correct location: `ls -la /var/www/laravel`
4. Permissions are correct: `sudo chmod -R 775 /var/www/laravel/storage`
5. Check error logs: `sudo tail -f /var/log/nginx/error.log`

### 500 Error

Usually a permissions or configuration issue:

```bash
# Check Laravel logs
sudo tail -f /var/www/laravel/storage/logs/laravel.log

# Fix permissions
sudo chmod -R 775 /var/www/laravel/storage
sudo chmod -R 775 /var/www/laravel/bootstrap/cache

# Clear and rebuild cache
cd /var/www/laravel
sudo php artisan config:clear
sudo php artisan cache:clear
sudo php artisan config:cache
```

---

## 📚 Additional Resources

- **CloudFormation Template**: `cloudformation-template.yaml`
- **Laravel Documentation**: https://laravel.com/docs/deployment
- **AWS Free Tier**: https://aws.amazon.com/free/
- **AWS CloudFormation Guide**: https://docs.aws.amazon.com/cloudformation/

---

## ✅ Quick Reference

### Access Points

| What | Where |
|------|-------|
| AWS Console | https://console.aws.amazon.com/ |
| CloudFormation | Console → CloudFormation → Stacks |
| EC2 Instances | Console → EC2 → Instances |
| Security Groups | Console → EC2 → Security Groups |
| Key Pairs | Console → EC2 → Key Pairs |

### Important Paths

| Path | Description |
|------|-------------|
| `/var/www/laravel` | Laravel application root |
| `/var/www/laravel/public` | Web root (served by Nginx) |
| `/var/www/laravel/storage` | Storage and logs |
| `/etc/nginx/sites-available/laravel` | Nginx config |
| `/home/ubuntu/deploy-laravel.sh` | Deployment script |

### Deployment Checklist

- [ ] Create EC2 Key Pair
- [ ] Upload CloudFormation template
- [ ] Wait for stack to complete
- [ ] Copy public IP from Outputs
- [ ] SSH into server
- [ ] Upload/clone Laravel code
- [ ] Configure .env file
- [ ] Run deployment script
- [ ] Visit public IP in browser
- [ ] Celebrate! 🎉

---

## 🎉 You're Done!

Your Laravel application is now running on AWS Free Tier. Enjoy! 

For questions or issues, refer to the troubleshooting section above.

