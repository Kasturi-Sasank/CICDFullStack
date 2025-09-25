# SaveNServe Deployment Guide

This guide provides instructions for deploying the SaveNServe application using Docker Compose, CI/CD with GitHub Actions, and AWS.

## Local Development

1. Clone the repository
2. Run the application using Docker Compose:
   ```
   docker-compose up -d
   ```
3. Access the application at http://localhost

## Production Deployment

### Prerequisites

- Docker and Docker Compose installed
- AWS account with appropriate permissions
- GitHub repository for the project

### Setup Steps

1. **Configure Environment Variables**:
   - Copy `.env.example` to `.env`
   - Update the values with your credentials

2. **Deploy to AWS**:
   - Run the AWS deployment script:
     ```
     chmod +x aws-deploy.sh
     ./aws-deploy.sh
     ```

3. **CI/CD Pipeline**:
   - Push your code to GitHub
   - The GitHub Actions workflow will automatically:
     - Build and test the application
     - Create Docker images
     - Deploy to AWS

## Docker Configuration

- `frontend/Dockerfile`: Configuration for the React frontend
- `backend/Dockerfile`: Configuration for the Spring Boot backend
- `docker-compose.yml`: Local development configuration
- `docker-compose.prod.yml`: Production configuration

## AWS Infrastructure

Refer to `aws-setup.md` for detailed AWS infrastructure setup instructions.

## Deployment Scripts

- `deploy.sh`: Script for deploying the application on the EC2 instance
- `aws-deploy.sh`: Script for setting up and deploying to AWS EC2

## Troubleshooting

If you encounter any issues during deployment:

1. Check the Docker container logs:
   ```
   docker-compose logs
   ```

2. Verify AWS credentials and permissions
3. Ensure all required GitHub secrets are configured correctly