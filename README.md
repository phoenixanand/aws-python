CI/CD Pipeline for Python Flask Application using AWS

This project demonstrates how to build a complete CI/CD pipeline using AWS services to automate the build and deployment of a Python Flask application.
The pipeline uses AWS CodePipeline, CodeBuild, and CodeDeploy to automatically build a Docker image and deploy it to an EC2 instance whenever code changes are pushed to GitHub.

🏗️ Architecture

Developer → GitHub → AWS CodePipeline → AWS CodeBuild → AWS CodeDeploy → EC2 Instance (Docker Container)

Workflow

Developer pushes code to GitHub -> AWS CodePipeline detects changes in the repository -> AWS CodeBuild builds the application and Docker image -> AWS CodeDeploy deploys the application to EC2

The application runs inside a Docker container

⚙️ AWS Services Used
1) AWS CodePipeline

AWS CodePipeline is a fully managed CI/CD service that automates the software release process.

Responsibilities

Orchestrates the entire CI/CD workflow
Connects GitHub with build and deployment stages
Automatically triggers pipeline when code changes

Benefits

Fully managed service
Easy integration with AWS ecosystem
No infrastructure management required

2) AWS CodeBuild

AWS CodeBuild is a managed build service used to compile source code, run tests, and build Docker images.

Configuration Steps

Go to AWS CodeBuild
Create a Build Project
Configure the following:
Source Provider: GitHub
Repository: Your GitHub repository
Environment Type: Managed Image
Compute: EC2
OS: Ubuntu
Runtime: Standard
Image: Latest
Enable Privileged Mode (required for Docker builds)

IAM Role

Create a service role:
IAM → Roles → Create Role
Select CodeBuild service

Attach permissions for: SSM Parameter Store

Docker image build access

Secure Docker Credentials using AWS Systems Manager

To avoid exposing Docker credentials in the code, we store them in AWS Parameter Store.

Navigate to:

AWS Systems Manager → Parameter Store → Create Parameter

Create parameters:

Parameter Name	Type
docker-credentials-username	SecureString
docker-credentials-password	SecureString
docker-credentials-url	SecureString

Example value:

docker.io

🔄 AWS CodePipeline Setup

Steps to create the pipeline:

Go to AWS CodePipeline
Click Create Pipeline
Enter:
Pipeline Name
Create New Service Role
Source Stage
Provider: GitHub (Latest Version)
Repository: Select your GitHub repo
Branch: main
Build Stage
Provider: AWS CodeBuild
Select the project created earlier.

Deployment Stage
Provider: AWS CodeDeploy

🚀 AWS CodeDeploy Setup

AWS CodeDeploy automates deployment to EC2 instances.

Step 1: Create Application
Go to:
CodeDeploy → Create Application
Settings:
Compute Platform: EC2 / On-Premises

Step 2: Create EC2 Instance
Launch an EC2 instance with:
Ubuntu
Docker installed

Always assign tags to EC2 instances to manage deployments easily.

Example tag:

Name = flask-app-server
Step 3: Install CodeDeploy Agent
SSH into the EC2 instance:

sudo apt update
sudo apt install ruby-full
sudo apt install wget

Download and install CodeDeploy agent.

Restart the agent:

sudo service codedeploy-agent restart
IAM Roles Required
CodeDeploy Service Role

IAM → Roles → Create Role

Service:
CodeDeploy
Attach necessary policies.
EC2 Instance Role
Create another role for EC2:
EC2RoleForCodeDeploy
Attach permissions required for deployment.
Attach the role to the EC2 instance:

EC2 → Actions → Security → Modify IAM Role

📦 Deployment Group

Deployment groups allow you to deploy to specific EC2 instances.

Steps:

Open CodeDeploy Application
Create Deployment Group
Select:
EC2 Instance
Tag-based deployment
Disable load balancer

📄 appspec.yml

The appspec.yml file must always be placed in the root directory of the repository.

📊 Verification

Check Docker images: sudo docker images
 
Check running containers:

docker ps
🆚 AWS CodePipeline vs Jenkins
Feature	AWS CodePipeline	Jenkins
Management	Fully managed	Self-managed
Infrastructure	No server required	Requires master/slave nodes
Scalability	Automatic	Manual scaling
Maintenance	Minimal	High maintenance
Security	IAM integration	Plugin-based

Organizations often prefer CodePipeline because it eliminates the need to maintain Jenkins servers.

📚 About AWS CodeCommit

AWS CodeCommit is a managed Git repository service similar to GitHub.

Advantages

Fully managed Git service
Highly scalable
Secure with IAM integration
Reliable and highly available
Limitations
Limited integrations outside AWS
Difficult to connect with external tools
Less ecosystem compared to GitHub

For this project, GitHub was used as the source repository.
