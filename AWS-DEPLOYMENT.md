# AWS Deployment Quick Reference

## Files Created

- **`cloudformation-template.yaml`** - Complete CloudFormation stack template
- **`AWS-CONSOLE-DEPLOYMENT.md`** - Step-by-step console deployment guide
- **`DEPLOYMENT.md`** - Detailed deployment documentation

## Quick Deploy (Using AWS Console)

### Step 1: Create Key Pair

1. Go to **AWS Console** → **EC2** → **Key Pairs**
2. Click **"Create key pair"**
3. Name: `laravel-demo-key`, Type: RSA, Format: .pem
4. Save the downloaded file securely
5. Set permissions: `chmod 400 ~/Downloads/laravel-demo-key.pem`

### Step 2: Deploy Stack

1. Go to **CloudFormation** → **Create stack**
2. Upload `cloudformation-template.yaml`
3. Stack name: `laravel-demo`
4. Select your key pair
5. Check acknowledgment box
6. Click **Submit**
7. Wait 5-10 minutes for completion

### Step 3: Get Your Server Info

1. Click **Outputs** tab
2. Copy your **PublicIP**
3. You now have: `http://YOUR_IP`

### Step 4: Deploy Laravel

```bash
# SSH to your server
ssh -i ~/Downloads/laravel-demo-key.pem ubuntu@YOUR_IP

# Clone your repo
sudo git clone YOUR_REPO_URL /var/www/laravel

# Deploy
sudo /home/ubuntu/deploy-laravel.sh
```

## What You Get

✅ **Free Tier Eligible Stack:**
- t3.micro EC2 instance (Ubuntu 22.04 LTS)
- 30GB storage
- Full VPC with public subnet
- Security groups (SSH, HTTP, HTTPS)
- Pre-installed: Nginx, PHP 8.1, MySQL, Composer, Node.js

## After Deployment

1. **Get your server IP** from the Outputs tab in CloudFormation
2. **SSH into server**: `ssh -i ~/Downloads/laravel-demo-key.pem ubuntu@YOUR_IP`
3. **Deploy Laravel app**: Copy your code to `/var/www/laravel`
4. **Run deployment script**: `sudo /home/ubuntu/deploy-laravel.sh`
5. **Access**: `http://YOUR_IP`

## Stack Components

```
┌─────────────────────────────────────┐
│          Internet Gateway           │
└──────────────┬──────────────────────┘
               │
┌──────────────┴──────────────────────┐
│     VPC (10.0.0.0/16)               │
│  ┌──────────────────────────────┐   │
│  │  Public Subnet (10.0.1.0/24) │   │
│  │  ┌────────────────────────┐  │   │
│  │  │   EC2 Instance         │  │   │
│  │  │   - Ubuntu 22.04       │  │   │
│  │  │   - Nginx              │  │   │
│  │  │   - PHP 8.1            │  │   │
│  │  │   - MySQL              │  │   │
│  │  │   - Composer           │  │   │
│  │  │   - Node.js            │  │   │
│  │  └────────────────────────┘  │   │
│  └──────────────────────────────┘   │
└─────────────────────────────────────┘
```

## Security Groups

| Port | Protocol | Source    | Purpose              |
|------|----------|-----------|----------------------|
| 22   | TCP      | 0.0.0.0/0 | SSH access          |
| 80   | TCP      | 0.0.0.0/0 | HTTP                |
| 443  | TCP      | 0.0.0.0/0 | HTTPS               |
| 8000 | TCP      | 0.0.0.0/0 | Laravel dev server  |

## Parameters

| Parameter      | Default                | Description                          |
|----------------|------------------------|--------------------------------------|
| AmiId          | ami-01fd6fa49060e89a6 | Ubuntu 22.04 LTS AMI                |
| KeyPairName    | (required)             | EC2 Key Pair for SSH                |
| InstanceType   | t3.micro               | EC2 instance type (free tier)       |
| SSHLocation    | 0.0.0.0/0             | IP range for SSH access             |

## Cost Estimate (Free Tier)

- **First 12 months**: FREE (under Free Tier limits)
- **After Free Tier**: ~$8-10/month
  - t3.micro: ~$7.50/month
  - 30GB EBS: ~$2.40/month
  - Data transfer: Usually free for demo apps

⚠️ **Remember**: Delete the stack when done testing to avoid charges!

## Troubleshooting

### Stack Creation Failed
1. Go to **CloudFormation** → Select your stack
2. Click **Events** tab
3. Look for `CREATE_FAILED` status
4. Check "Status reason" column for details

### Can't SSH
- Verify security group allows your IP (EC2 → Security Groups)
- Check key pair permissions: `chmod 400 laravel-demo-key.pem`
- Ensure instance is running (EC2 → Instances)

### Laravel Not Working
- SSH into server and check logs: `sudo tail -f /var/log/nginx/error.log`
- Verify permissions: `sudo chmod -R 775 /var/www/laravel/storage`
- Run deployment script: `sudo /home/ubuntu/deploy-laravel.sh`

## Documentation

- **Full deployment guide**: See `AWS-CONSOLE-DEPLOYMENT.md` (recommended)
- **Alternative guide**: See `DEPLOYMENT.md`
- **CloudFormation template**: See `cloudformation-template.yaml`

## Support

For detailed information, refer to:
- [DEPLOYMENT.md](./DEPLOYMENT.md) - Complete deployment guide
- [AWS CloudFormation Docs](https://docs.aws.amazon.com/cloudformation/)
- [Laravel Deployment Docs](https://laravel.com/docs/deployment)

