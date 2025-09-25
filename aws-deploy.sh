#!/bin/bash

# AWS EC2 deployment script for SaveNServe

# Set AWS region
AWS_REGION=${AWS_REGION:-ap-south-1}
export AWS_DEFAULT_REGION=$AWS_REGION

# Check if instance is running
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=cicd_fullstack" "Name=instance-state-name,Values=running" \
  --query "Reservations[0].Instances[0].InstanceId" \
  --output text)

if [ "$INSTANCE_ID" == "None" ] || [ -z "$INSTANCE_ID" ]; then
  echo "No running instance found. Creating a new EC2 instance..."
  
  # Create security group
  SG_ID=$(aws ec2 create-security-group \
    --group-name savenserve-sg \
    --description "Security group for SaveNServe application" \
    --query "GroupId" \
    --output text)
  
  # Configure security group
  aws ec2 authorize-security-group-ingress \
    --group-id $SG_ID \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0
  
  aws ec2 authorize-security-group-ingress \
    --group-id $SG_ID \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0
  
  aws ec2 authorize-security-group-ingress \
    --group-id $SG_ID \
    --protocol tcp \
    --port 443 \
    --cidr 0.0.0.0/0
  
  aws ec2 authorize-security-group-ingress \
    --group-id $SG_ID \
    --protocol tcp \
    --port 8081 \
    --cidr 0.0.0.0/0
  
  # Launch EC2 instance
  INSTANCE_ID=$(aws ec2 run-instances \
    --image-id ami-0c55b159cbfafe1f0 \
    --instance-type t2.medium \
    --key-name savenserve \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=cicd_fullstack}]" \
    --query "Instances[0].InstanceId" \
    --output text)
  
  echo "Waiting for instance to be running..."
  aws ec2 wait instance-running --instance-ids $INSTANCE_ID
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=cicd_fullstack}]" \
    --query "Instances[0].InstanceId" \
    --output text)
  
  echo "Waiting for instance to be running..."
  aws ec2 wait instance-running --instance-ids $INSTANCE_ID
fi

# Get instance public IP
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

echo "Instance is running with IP: $PUBLIC_IP"

# Wait for SSH to be available
echo "Waiting for SSH to be available..."
while ! nc -z $PUBLIC_IP 22; do
  sleep 5
done

# Copy deployment files to EC2
echo "Copying deployment files to EC2..."
scp -o StrictHostKeyChecking=no -i "savenserve-key.pem" \
  docker-compose.prod.yml \
  .env \
  deploy.sh \
  ec2-user@$PUBLIC_IP:~/savenserve/

# Execute deployment script on EC2
echo "Executing deployment script on EC2..."
ssh -o StrictHostKeyChecking=no -i "savenserve-key.pem" ec2-user@$PUBLIC_IP \
  "cd ~/savenserve && chmod +x deploy.sh && ./deploy.sh"

echo "Deployment completed successfully!"
echo "Application is accessible at: http://$PUBLIC_IP"