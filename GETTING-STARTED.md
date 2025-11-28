# 🎉 AWS CloudFormation Stack - Ready to Deploy!

## What I've Created for You

I've created a complete AWS CloudFormation stack for deploying your Laravel application to AWS Free Tier using the AWS Console (no command-line tools required!).

### 📁 Files Created

1. **`cloudformation-template.yaml`** (Main Template)
   - Complete infrastructure as code
   - VPC, subnets, security groups, IAM roles
   - EC2 instance with Ubuntu 22.04 LTS
   - Pre-installed: Nginx, PHP 8.1, MySQL, Composer, Node.js
   - Free Tier eligible (t3.micro instance)

2. **`AWS-CONSOLE-DEPLOYMENT.md`** (Complete Step-by-Step Guide)
   - Detailed instructions with screenshots descriptions
   - Every click and step explained
   - Troubleshooting tips
   - Security best practices

3. **`AWS-DEPLOYMENT.md`** (Quick Reference)
   - Quick start guide
   - Command cheat sheet
   - Visual diagrams
   - Common scenarios

4. **`DEPLOYMENT.md`** (Technical Guide)
   - Detailed deployment instructions
   - Server configuration details
   - Advanced troubleshooting

5. **`.env.aws.example`** (Environment Config)
   - Production-ready .env template
   - AWS-specific configurations
   - Database options (SQLite/MySQL)

### 🚀 How to Deploy (4 Easy Steps)

#### Using AWS Console (Recommended - No CLI needed!)

**Step 1: Create Key Pair**
1. Log in to [AWS Console](https://console.aws.amazon.com/)
2. Go to **EC2** → **Key Pairs**
3. Click **"Create key pair"**
4. Name: `laravel-demo-key`, Type: RSA, Format: .pem
5. Save the downloaded file

**Step 2: Deploy Stack**
1. Go to **CloudFormation** → **Create stack**
2. Upload `cloudformation-template.yaml`
3. Enter stack name: `laravel-demo`
4. Select your key pair
5. Check acknowledgment box
6. Click **Submit**

**Step 3: Wait for Completion**
- Wait 5-10 minutes
- Status will change to `CREATE_COMPLETE`

**Step 4: Deploy Your Laravel App**
1. Get IP from **Outputs** tab
2. SSH: `ssh -i ~/Downloads/laravel-demo-key.pem ubuntu@YOUR_IP`
3. Upload your Laravel code
4. Run: `sudo /home/ubuntu/deploy-laravel.sh`

**📖 See detailed walkthrough**: [AWS-CONSOLE-DEPLOYMENT.md](./AWS-CONSOLE-DEPLOYMENT.md)

### 📦 What Gets Deployed

```
AWS Free Tier Stack
├── VPC (10.0.0.0/16)
│   ├── Internet Gateway
│   ├── Public Subnet (10.0.1.0/24)
│   └── Route Tables
├── Security Group
│   ├── Port 22 (SSH)
│   ├── Port 80 (HTTP)
│   ├── Port 443 (HTTPS)
│   └── Port 8000 (Laravel Dev)
├── IAM Role & Instance Profile
│   ├── SSM Access
│   └── CloudWatch Logs
└── EC2 Instance (t3.micro)
    ├── Ubuntu 22.04 LTS
    ├── Nginx
    ├── PHP 8.1 (all extensions)
    ├── MySQL Server
    ├── Composer
    ├── Node.js 18.x
    └── 30GB Storage (gp3)
```

### 🎯 After Deployment

Once your stack is deployed, you need to copy your Laravel application:

#### Method 1: Git Clone (Easiest)

```bash
# SSH into server
ssh -i ~/Downloads/laravel-demo-key.pem ubuntu@YOUR_IP

# Clone your repo
sudo git clone https://github.com/yourusername/your-repo.git /var/www/laravel

# Run deployment
sudo /home/ubuntu/deploy-laravel.sh
```

#### Method 2: SCP Upload

```bash
# Create tarball (exclude vendor and node_modules)
cd /Users/davesuy/website-projects/laravel-aws
tar -czf laravel-app.tar.gz \
  --exclude='vendor' \
  --exclude='node_modules' \
  --exclude='.git' \
  .

# Upload
scp -i ~/Downloads/laravel-demo-key.pem laravel-app.tar.gz ubuntu@YOUR_IP:~

# SSH and deploy
ssh -i ~/Downloads/laravel-demo-key.pem ubuntu@YOUR_IP
sudo mkdir -p /var/www/laravel
sudo tar -xzf laravel-app.tar.gz -C /var/www/laravel
sudo /home/ubuntu/deploy-laravel.sh
```

### 💰 Cost Breakdown

**First 12 Months (Free Tier):**
- ✅ 750 hours/month of t3.micro (FREE)
- ✅ 30GB storage (FREE)
- ✅ 15GB data transfer out (FREE)

**After Free Tier:**
- t3.micro: ~$7.50/month
- 30GB gp3: ~$2.40/month
- Data transfer: Usually minimal for demo
- **Total: ~$10/month**

⚠️ **Don't forget to delete when done!**
```bash
./deploy.sh delete
```

### 📝 Configuration Options

The CloudFormation template accepts these parameters:

| Parameter    | Default               | Description                |
|--------------|----------------------|----------------------------|
| AmiId        | ami-01fd6fa49060e89a6 | Ubuntu 22.04 LTS          |
| KeyPairName  | (required)            | Your EC2 key pair name    |
| InstanceType | t3.micro              | Free tier instance        |
| SSHLocation  | 0.0.0.0/0            | IP range for SSH access   |

### 🔐 Security Best Practices

1. **Restrict SSH Access:**
   - After deployment, go to **EC2 → Security Groups**
   - Find your stack's security group
   - Edit inbound rules for SSH (port 22)
   - Change from `0.0.0.0/0` to your IP address (e.g., `YOUR_IP/32`)
   - Get your IP: Visit https://whatismyipaddress.com/

2. **Set Up SSL (for production):**
   - SSH into your server
   - Install certbot:
     ```bash
     sudo apt-get install -y certbot python3-certbot-nginx
     sudo certbot --nginx -d yourdomain.com
     ```

3. **Secure MySQL:**
   - SSH into your server
   - Run MySQL secure installation:
     ```bash
     sudo mysql_secure_installation
     ```

### 📚 Documentation Links

- **[AWS-CONSOLE-DEPLOYMENT.md](./AWS-CONSOLE-DEPLOYMENT.md)** - Complete step-by-step console guide
- **[AWS-DEPLOYMENT.md](./AWS-DEPLOYMENT.md)** - Quick reference
- **[DEPLOYMENT.md](./DEPLOYMENT.md)** - Technical deployment guide
- **[cloudformation-template.yaml](./cloudformation-template.yaml)** - Template code

### 🐛 Troubleshooting

**Stack creation fails?**
- Go to **CloudFormation → Your Stack → Events** tab
- Look for events with status `CREATE_FAILED`
- Check the "Status reason" column for error details
- Common issues:
  - Missing IAM acknowledgment checkbox
  - Key pair doesn't exist in the region
  - Service limits reached

**Can't SSH?**
- Check key permissions: `chmod 400 laravel-demo-key.pem`
- Verify security group allows your IP (EC2 → Security Groups)
- Ensure instance is running (EC2 → Instances)
- Make sure you're using the correct username: `ubuntu`

**Laravel not working?**
```bash
# SSH in and check logs
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/www/laravel/storage/logs/laravel.log

# Fix permissions
sudo chmod -R 775 /var/www/laravel/storage
sudo chmod -R 775 /var/www/laravel/bootstrap/cache
```

### ✅ Testing Your Deployment

1. **Deploy the stack** via AWS Console (5-10 minutes)

2. **Get your IP** from CloudFormation Outputs tab

3. **Visit** `http://YOUR_IP` - You should see the Laravel welcome page!

### 🎓 What You Learned

This stack demonstrates:
- ✅ Infrastructure as Code with CloudFormation
- ✅ VPC networking and security groups
- ✅ EC2 instance configuration
- ✅ User data scripts for automation
- ✅ IAM roles and policies
- ✅ AWS Free Tier optimization

### 🚀 Next Steps

1. **Deploy the stack** using AWS Console
2. **Copy your Laravel app** to the server
3. **Configure your .env** file (use `.env.aws.example` as template)
4. **Run the deployment script** on the server
5. **Access your app** at the public IP
6. **Set up a domain** (optional)
7. **Add SSL certificate** (optional)

### 🆘 Need Help?

- Check `AWS-CONSOLE-DEPLOYMENT.md` for detailed step-by-step instructions
- Review AWS CloudFormation events for errors in the console
- Ensure you have an AWS account created and logged in

### 🎉 You're Ready!

Everything is set up and ready to deploy via AWS Console. Just follow the guide in:

**[AWS-CONSOLE-DEPLOYMENT.md](./AWS-CONSOLE-DEPLOYMENT.md)**

And you'll have a fully functional Laravel server running on AWS in about 15 minutes!

---

**Remember:** This is configured for Free Tier demo purposes. For production, consider:
- Using RDS for database instead of local MySQL
- Setting up Auto Scaling
- Using Application Load Balancer
- Implementing CloudFront CDN
- Setting up proper monitoring and alerts
- Using Elastic IP for static IP address
- Implementing automated backups

Good luck with your deployment! 🚀

