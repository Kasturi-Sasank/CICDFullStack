# AWS Infrastructure Setup for SaveNServe

## EC2 Instance Setup

1. Launch an EC2 instance with the following specifications:
   - Amazon Linux 2 AMI
   - t2.medium instance type (2 vCPU, 4 GB RAM)
   - 30 GB EBS storage
   - Security group with the following inbound rules:
     - SSH (port 22) from your IP
     - HTTP (port 80) from anywhere
     - HTTPS (port 443) from anywhere
     - Custom TCP (port 8080) from anywhere

2. Connect to your EC2 instance:
   ```
   ssh -i "your-key.pem" ec2-user@your-ec2-public-dns
   ```

3. Install Docker and Docker Compose:
   ```
   sudo yum update -y
   sudo amazon-linux-extras install docker -y
   sudo service docker start
   sudo systemctl enable docker
   sudo usermod -a -G docker ec2-user
   sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose
   ```

4. Create project directory:
   ```
   mkdir -p ~/savenserve
   ```

## Environment Variables Setup

Create a `.env` file in the EC2 instance's savenserve directory with the following variables:

```
DB_USERNAME=root
DB_PASSWORD=your_secure_password
DOCKER_HUB_USERNAME=your_dockerhub_username
AWS_REGION=us-east-1
```

## GitHub Secrets Setup

Add the following secrets to your GitHub repository:

1. `AWS_ACCESS_KEY_ID`: Your AWS access key
2. `AWS_SECRET_ACCESS_KEY`: Your AWS secret key
3. `AWS_REGION`: Your AWS region (e.g., us-east-1)
4. `EC2_HOST`: Your EC2 instance's public DNS or IP
5. `SSH_PRIVATE_KEY`: Your EC2 instance's private key
6. `DOCKER_HUB_USERNAME`: Your Docker Hub username
7. `DOCKER_HUB_TOKEN`: Your Docker Hub access token

## Domain and SSL Setup (Optional)

1. Register a domain in Route 53 or use an existing domain
2. Create an A record pointing to your EC2 instance's public IP
3. Set up SSL with AWS Certificate Manager or Let's Encrypt

## Monitoring and Logging

1. Set up CloudWatch for monitoring:
   ```
   sudo yum install -y amazon-cloudwatch-agent
   ```

2. Configure CloudWatch agent for logs and metrics