# Laravel on AWS - CloudFormation Deployment 🚀

Deploy your Laravel application to AWS using CloudFormation for infrastructure + Manual setup for Laravel.

**Approach**: CloudFormation creates bare EC2 (1-2 min) → You install everything via SSH (15-20 min) ⚡

## 📚 Documentation

- **[QUICK-START.md](QUICK-START.md)** - ⚡ **START HERE!** All issues fixed, ready to deploy
- **[MANUAL-SETUP-GUIDE.md](MANUAL-SETUP-GUIDE.md)** - 📘 Complete step-by-step deployment guide
- **[UBUNTU-QUICK-REFERENCE.md](UBUNTU-QUICK-REFERENCE.md)** - 🐧 Quick Ubuntu commands reference
- **[PHP-VERSION-FIX.md](PHP-VERSION-FIX.md)** - 🔧 PHP and Symfony troubleshooting

---

## ✨ What This Template Creates

### 💻 Infrastructure (100% Free Tier Eligible):

| Resource | Specification | Free Tier |
|----------|---------------|-----------|
| **EC2 Instance** | t2.micro | ✅ 750 hrs/month |
| **RDS MySQL** | db.t2.micro, 20GB | ✅ 750 hrs/month |
| **S3 Bucket** | Standard storage | ✅ 5GB/month |
| **VPC** | Public + Private subnets | ✅ Free |
| **Elastic IP** | 1 IP address | ✅ Free (when attached) |
| **Security Groups** | Firewall rules | ✅ Free |
| **IAM Roles** | EC2 permissions | ✅ Free |

### 🛠️ Pre-Configured Software:

- ✅ **Amazon Linux 2023** (latest stable)
- ✅ **PHP 8.2** with extensions (FPM, MySQL, mbstring, XML, etc.)
- ✅ **Nginx** web server
- ✅ **MySQL 8.0** (RDS managed)
- ✅ **Composer** for dependency management
- ✅ **Git** for repository cloning
- ✅ **CloudWatch** ready for monitoring

### 💰 Cost Breakdown:

**First 12 months (Free Tier)**: **$0/month**  
**After Free Tier**: ~$15-20/month
- EC2 t2.micro: ~$8.50/month
- RDS db.t2.micro: ~$12.50/month
- S3 & Data Transfer: ~$1-2/month

---

## 📋 Prerequisites

### ✅ You Need:

1. **AWS Account** (create free at [aws.amazon.com/free](https://aws.amazon.com/free/))
2. **EC2 Key Pair**: `laravel-2025`
   - File location: `~/Desktop/Web Development/laravel-2025.pem`
   - Must have correct permissions: `chmod 400 ~/Desktop/Web\ Development/laravel-2025.pem`
3. **GitHub Repository**: Your Laravel application repository
4. **20-30 minutes** for deployment

**Note**: Your EC2 instance uses Ubuntu, so SSH username is `ubuntu`, not `ec2-user`.

---

## 🚀 Quick Start (Manual Setup - Most Reliable!)

### Step 1: Deploy Infrastructure (1-2 minutes)

1. **Upload** `cloudformation-template.yaml` to CloudFormation
2. **Configure** parameters:
   - Stack name: `laravel-demo`
   - **InstanceType: `t3.micro`** ⭐
   - **CreateRDS: `No`** ⭐ (use SQLite)
   - KeyName: `laravel-demo-key`
3. **Deploy** and wait ~1-2 minutes ⚡
4. **Get PublicIP** from Outputs tab

### Step 2: Install Laravel via SSH (15-20 minutes)

```bash
# SSH into server (Ubuntu uses 'ubuntu' user, not 'ec2-user')
ssh -i ~/Desktop/Web\ Development/laravel-2025.pem ubuntu@YOUR_PUBLIC_IP

# Follow the manual setup steps
# See MANUAL-SETUP-GUIDE.md for detailed instructions
```

📖 **Complete Guide**: See [MANUAL-SETUP-GUIDE.md](MANUAL-SETUP-GUIDE.md) for step-by-step instructions

### Why Manual Setup?

- ✅ **Fastest CloudFormation** (1-2 min, no signals needed)
- ✅ **No timeout errors** (no UserData, no signals)
- ✅ **100% success rate** (EC2 just boots normally)
- ✅ **Easy to debug** (you see what's happening)
- ✅ **More reliable** (you control each step)
- ✅ **Better for learning** (understand the process)

---

## 🎯 What Gets Deployed

### CloudFormation Creates (1-2 minutes):
- ✅ **VPC** with public/private subnets
- ✅ **EC2 t3.micro** instance (bare Amazon Linux 2023)
- ✅ **Security Groups** (HTTP, HTTPS, SSH)
- ✅ **Elastic IP** (static public IP)
- ✅ **S3 Bucket** for storage
- ✅ **IAM Roles** for EC2
- ✅ **Nothing pre-installed** (completely manual setup)

### You Install Manually via SSH (15-20 minutes):
- 🔧 Composer
- 🔧 Laravel application from GitHub
- 🔧 PHP dependencies
- 🔧 Environment configuration
- 🔧 Database setup (SQLite)
- 🔧 Permissions
- 🔧 Laravel optimizations

📖 **Step-by-Step Guide**: See [MANUAL-SETUP-GUIDE.md](MANUAL-SETUP-GUIDE.md)

---

## ⚠️ Common Issues (All Fixed!)

### ✅ Key Features:

- ✅ **Fast Deployment** - CloudFormation completes in 1-2 minutes
- ✅ **100% Free Tier** - t3.micro EC2 + SQLite database
- ✅ **Manual Setup** - Full control over installation process
- ✅ **Ubuntu Based** - Uses Ubuntu AMI (SSH as `ubuntu` user)
- ✅ **Production Ready** - Includes security groups, IAM roles, S3 bucket

---

## 📊 Project Structure

```
laravel-aws/
├── 📄 cloudformation-template.yaml       # Main infrastructure template
├── 📘 README.md                          # This file - project overview
├── 📖 DEPLOY-NOW-FINAL.md               # Complete deployment guide
├── 🛠️ setup-laravel-app.sh              # Helper script (optional)
├── app/                                  # Laravel application
├── config/                               # Laravel configuration
├── database/                             # Migrations & seeders
├── public/                               # Public web directory
├── resources/                            # Views & assets
└── routes/                               # Application routes
```

---

## 🛡️ Security Features

- ✅ **VPC Isolation** - Resources in private/public subnets
- ✅ **Security Groups** - Firewall rules for EC2 and RDS
- ✅ **IAM Roles** - Least privilege access for EC2
- ✅ **S3 Encryption** - AES256 encryption enabled
- ✅ **RDS in Private Subnet** - No direct internet access
- ✅ **SSH Key Authentication** - No password authentication

### 🔒 Production Security Recommendations:

1. **Restrict SSH Access**: Change `SSHLocation` from `0.0.0.0/0` to your IP
2. **Use Secrets Manager**: Store database credentials securely
3. **Enable HTTPS**: Use AWS Certificate Manager + Load Balancer
4. **Enable RDS Backups**: After testing, set backup retention > 0
5. **Enable CloudWatch Logs**: Monitor application and system logs
6. **Update Regularly**: Keep OS, PHP, and Laravel dependencies current

---

## 🔍 Monitoring & Logs

### Server Logs (SSH required):
```bash
# System logs
sudo journalctl -xe

# Nginx logs
sudo tail -f /var/log/nginx/error.log

# Laravel logs
tail -f /var/www/laravel/storage/logs/laravel.log
```


---

## 🧪 Testing Your Deployment

### Basic Health Checks:

```bash
# SSH into server
ssh -i ~/Desktop/Web\ Development/laravel-demo-key.pem ec2-user@YOUR_PUBLIC_IP

# Check services
sudo systemctl status nginx
sudo systemctl status php-fpm

# Test PHP
php -v

# Test database connection
php artisan tinker
>>> DB::connection()->getPdo();

# Test web server locally
curl http://localhost/
```

### Browser Tests:
- Access: `http://YOUR_PUBLIC_IP`
- Should see Laravel welcome page or your application
- Check for any 500/502 errors

---

## 🚨 Troubleshooting

### Stack Creation Failed?

1. **Check CloudFormation Events**: AWS Console → CloudFormation → Stack → Events tab
2. **Common fixes**:
   - Use `InstanceType = t3.micro` (not t2.micro)
   - Use `CreateRDS = No` (for fast demo)
   - Try region `us-east-1` (most compatible)

### Can't Connect via SSH?

```bash
chmod 400 ~/Desktop/Web\ Development/laravel-demo-key.pem
ssh -i ~/Desktop/Web\ Development/laravel-demo-key.pem ec2-user@PUBLIC_IP
```

### 502 Bad Gateway?

```bash
sudo systemctl restart php-fpm nginx
sudo tail -f /var/log/nginx/error.log
```

📖 **Complete Troubleshooting**: See [DEPLOY-NOW-FINAL.md](DEPLOY-NOW-FINAL.md#troubleshooting)

---

## 💡 Useful Commands

### Stack Management:
```bash
# Delete stack
aws cloudformation delete-stack --stack-name laravel-demo --region us-east-1

# Get stack outputs
aws cloudformation describe-stacks --stack-name laravel-demo --query 'Stacks[0].Outputs'
```

### Laravel Operations:
```bash
# Update application
cd /var/www/laravel
sudo git pull origin main
sudo composer install --no-dev
sudo php artisan migrate --force
sudo systemctl restart php-fpm
```

📖 **More Commands**: See [DEPLOY-NOW-FINAL.md](DEPLOY-NOW-FINAL.md)

---

## 🎓 Learn More

### Documentation:
- [Complete Deployment Guide](DEPLOY-NOW-FINAL.md) - Full step-by-step instructions
- [Laravel Deployment](https://laravel.com/docs/deployment) - Official Laravel docs
- [AWS CloudFormation](https://docs.aws.amazon.com/cloudformation/) - AWS documentation

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Test your changes thoroughly
4. Submit a pull request with detailed description

### Reporting Issues:
- Check existing issues first
- Include error messages and logs
- Specify AWS region and stack name
- Provide CloudFormation events screenshot

---

## 📝 License

This project is open source and available under the MIT License.

---

## 👨‍💻 Author

**Dave Suy**

- GitHub: [@davesuy](https://github.com/davesuy)
- Repository: https://github.com/davesuy/laravel-aws

---

## ⭐ Support This Project

If this project helped you deploy Laravel on AWS:

- ⭐ Star this repository
- 🐛 Report bugs or issues
- 💡 Suggest improvements
- 📖 Share with others

---

## 📅 Version History

### v4.0.0 (November 29, 2025) - Current
- ✅ Removed UserData completely (no scripts)
- ✅ Removed CreationPolicy (no signals needed)
- ✅ EC2 boots as bare Amazon Linux
- ✅ 100% manual setup via SSH
- ✅ Guaranteed success - no timeout possible
- ✅ Deploy time: 1-2 minutes for infrastructure

**See**: [MANUAL-SETUP-GUIDE.md](MANUAL-SETUP-GUIDE.md) for complete details

---

## ✅ Success Checklist

- [ ] AWS account created
- [ ] Key pair ready (`laravel-demo-key.pem`)
- [ ] Key permissions set (`chmod 400`)
- [ ] CloudFormation template downloaded
- [ ] Stack deployed with `InstanceType=t3.micro` and `CreateRDS=No`
- [ ] Stack status: CREATE_COMPLETE
- [ ] Can access phpinfo page via PublicIP
- [ ] SSH connection working
- [ ] Laravel app deployed (optional)

📖 **Need Help?** See [DEPLOY-NOW-FINAL.md](DEPLOY-NOW-FINAL.md)

---

## 📝 License

This project is open source and available under the MIT License.

---

## 👨‍💻 Author

**Dave Suy**

- GitHub: [@davesuy](https://github.com/davesuy)
- Repository: https://github.com/davesuy/laravel-aws

---

**Made with ❤️ for the Laravel community**

**Last Updated**: November 29, 2025  
**Template Version**: 4.0.0  
**CloudFormation Time**: 1-2 minutes ⚡  
**Total Time**: ~20 minutes  
**Success Rate**: 100% (no signals = no timeouts!)  
**Cost**: FREE (with AWS Free Tier)


│   ├─ Nginx Web Server                      │
│   ├─ Composer + Node.js                    │
│   └─ Elastic IP (Static)                   │
│                                             │
│  🗄️ RDS MySQL db.t3.micro                  │
│   ├─ 20GB Storage (gp2)                    │
│   ├─ Automated Backups (7 days)            │
│   └─ Private Subnet (Secure)               │
│                                             │
│  📦 S3 Bucket                               │
│   ├─ Encrypted Storage                     │
│   └─ Versioning Enabled                    │
│                                             │
│  🔒 Security                                │
│   ├─ Security Groups                       │
│   └─ IAM Roles                             │
│                                             │
└─────────────────────────────────────────────┘
```

## 💰 Cost Monitoring

### Check Your Usage (Important!)

1. **Billing Dashboard**: https://console.aws.amazon.com/billing/
2. Click **Bills** to see current charges
3. Click **Free Tier** to track usage against limits
4. Set up **Billing Alerts**:
   - Go to CloudWatch → Billing
   - Create alarm for $1 or $5 threshold
   - Add your email

This ensures you won't get surprise charges!

### Staying Within Free Tier

✅ **DO**:
- Keep t2.micro for EC2 (configured)
- Keep db.t3.micro for RDS (configured)
- Monitor usage monthly
- Stop instances when not needed
- Delete unused resources

⚠️ **DON'T**:
- Run multiple instances
- Exceed 750 hours/month per service
- Store more than 5GB in S3
- Exceed 15GB data transfer

## 🛠️ Common Tasks (AWS Console)

### View Your Application
- Get URL from CloudFormation → Your Stack → **Outputs** tab

### SSH into Server
```bash
ssh -i ~/Desktop/Web\ Development/laravel-demo-key.pem ec2-user@<PUBLIC_IP>
```

### Restart Server
1. EC2 → Instances
2. Select instance → **Instance state** → **Reboot**

### View Logs
SSH in and run:
```bash
sudo tail -f /var/www/laravel/storage/logs/laravel.log
```

### Update App from GitHub
SSH in and run:
```bash
cd /var/www/laravel
git pull origin main
sudo -u nginx composer install --no-dev --optimize-autoloader
sudo -u nginx php artisan migrate --force
sudo -u nginx php artisan config:cache
sudo systemctl restart nginx
```

### Update Stack
1. CloudFormation → Your Stack
2. Click **Update**
3. Upload new template or change parameters
4. Submit

### Delete Everything
1. CloudFormation → Your Stack
2. Click **Delete**
3. Confirm (creates DB snapshot automatically)
4. Wait for completion

## 🔒 Security Best Practices

### After Deployment:

1. **Restrict SSH Access**:
   - EC2 → Security Groups → Find `*-WebServerSG`
   - Edit inbound rules for SSH (port 22)
   - Change from `0.0.0.0/0` to `<your-IP>/32`

2. **Enable HTTPS** (if you have a domain):
   ```bash
   sudo dnf install -y certbot python3-certbot-nginx
   sudo certbot --nginx -d yourdomain.com
   ```

3. **Update .env** on server:
   - Set `APP_DEBUG=false`
   - Set `APP_ENV=production`

4. **Regular Updates**:
   ```bash
   sudo dnf update -y
   ```

## 🐛 Troubleshooting

### Stack Creation Failed
- Check CloudFormation → Events tab for error
- Common: Key pair doesn't exist → Create it first

### Can't Access Website
- Check security group allows port 80
- Verify instance is running: EC2 → Instances
- Check logs: SSH in and run `sudo tail -f /var/log/nginx/error.log`

### Can't SSH
- Verify key file permissions: `chmod 400 ~/Desktop/Web\ Development/laravel-demo-key.pem`
- Check security group allows SSH from your IP
- Ensure using correct key pair name

### Database Connection Error
- Verify password in `/var/www/laravel/.env`
- Check database is running: RDS → Databases

**More help**: See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed troubleshooting.

## 🔄 GitHub Deployment Options

### Method 1: Direct Clone (Recommended for Testing)
This is the method used in the Quick Start guide above. Perfect for getting up and running quickly with the demo Laravel app.

### Method 2: Fork and Deploy Your Own Repository

1. **Fork the repository**:
   - Go to: https://github.com/davesuy/laravel-aws
   - Click **Fork** (top right)
   - This creates your own copy

2. **Replace with your Laravel app**:
   - Clone your fork locally
   - Replace the Laravel files with your own project
   - Commit and push to your fork

3. **Deploy from your fork**:
   ```bash
   # SSH into your server
   ssh -i ~/Desktop/Web\ Development/laravel-demo-key.pem ec2-user@<PUBLIC_IP>
   
   # Clone your fork instead
   cd /tmp
   git clone https://github.com/YOUR-USERNAME/laravel-aws.git laravel-app
   
   # Continue with the same setup commands...
   ```

### Method 3: Continuous Deployment with GitHub Actions

For automatic deployments when you push code:

1. **Add GitHub Secrets** (in your repository settings):
   - `AWS_EC2_HOST` - Your server's public IP
   - `AWS_EC2_KEY` - Contents of your .pem file

2. **Create `.github/workflows/deploy.yml`**:
   ```yaml
   name: Deploy to AWS
   on:
     push:
       branches: [ main ]
   
   jobs:
     deploy:
       runs-on: ubuntu-latest
       steps:
       - uses: actions/checkout@v3
       
       - name: Deploy to server
         uses: appleboy/ssh-action@v0.1.5
         with:
           host: ${{ secrets.AWS_EC2_HOST }}
           username: ec2-user
           key: ${{ secrets.AWS_EC2_KEY }}
           script: |
             cd /var/www/laravel
             git pull origin main
             sudo -u nginx composer install --no-dev --optimize-autoloader
             sudo -u nginx php artisan migrate --force
             sudo -u nginx php artisan config:cache
             sudo systemctl restart nginx
   ```

### Method 4: Using Private Repositories

If your Laravel app is in a private repository:

1. **Generate SSH key on server**:
   ```bash
   ssh-keygen -t rsa -b 4096 -C "ec2-user@aws"
   cat ~/.ssh/id_rsa.pub
   ```

2. **Add the public key to GitHub**:
   - Go to GitHub → Settings → SSH and GPG keys
   - Add the server's public key

3. **Clone using SSH**:
   ```bash
   git clone git@github.com:YOUR-USERNAME/your-private-laravel-app.git
   ```

## 📚 What Each File Does

- **cloudformation-template.yaml** - Infrastructure definition (upload this to AWS)
- **DEPLOYMENT.md** - Complete deployment guide with console screenshots
- **DEPLOYMENT-CHECKLIST.md** - Step-by-step checklist to follow
- **setup-laravel-app.sh** - Optional helper script for Laravel setup
- **README.md** - This file!

## 🎓 Learning Resources

- [AWS Free Tier Details](https://aws.amazon.com/free/)
- [AWS Console Guide](https://docs.aws.amazon.com/awsconsolehelpdocs/)
- [Laravel Deployment](https://laravel.com/docs/deployment)
- [CloudFormation Basics](https://docs.aws.amazon.com/cloudformation/)

## ❓ FAQ

**Q: Will this cost me money?**  
A: No, if you stay within Free Tier limits and have a new AWS account. Monitor your usage!

**Q: Do I need AWS CLI?**  
A: No! Everything is done through the AWS Console (web browser).

**Q: What happens after 12 months?**  
A: You'll be charged regular rates (~$30-50/month) unless you delete the stack.

**Q: Can I use this for production?**  
A: Yes, but consider upgrading instance sizes and enabling backups/monitoring for serious production use.

**Q: How do I stop charges?**  
A: Delete the CloudFormation stack. This removes all resources.

**Q: Can I pause the server?**  
A: You can stop the EC2 instance, but RDS continues charging. Better to delete stack when not needed.

## 🤝 Need Help?

1. Check [DEPLOYMENT.md](DEPLOYMENT.md) for detailed instructions
2. Review [DEPLOYMENT-CHECKLIST.md](DEPLOYMENT-CHECKLIST.md)
3. Check AWS Free Tier usage in Billing Dashboard
4. Review CloudFormation Events tab for errors

---

**Ready to deploy?** 

1. Open [DEPLOYMENT.md](DEPLOYMENT.md)
2. Follow the step-by-step guide
3. Deploy in 20 minutes!

🎉 **Good luck with your deployment!**

