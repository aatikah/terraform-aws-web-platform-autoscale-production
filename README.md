# Terraform Web Platform

[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A production-ready, modular Terraform project for deploying an auto-scaling web platform on AWS with built-in security, monitoring, and high availability.

---
![Preview](https://github.com/aatikah/terraform-aws-web-platform-autoscale-production/blob/main/featured_image.png)


## 🎯 Overview

This Terraform project deploys a highly available, scalable web application infrastructure on AWS. It demonstrates Infrastructure as Code (IaC) best practices with modular design, environment separation, and comprehensive security controls.

## 📖 Detailed Walkthrough
For a comprehensive step-by-step guide, including screenshots and detailed explanations, check out the full tutorial on Medium:
[**Building a Production-Ready Auto-Scaling Web Platform on AWS with Terraform: A Complete Implementation Guide**](https://medium.com/p/2d25df7fce81?sk=30c755cbf1cb5a97ba9643cfd97b2e04)

### Key Highlights

- **Multi-environment support** (dev/prod) with isolated configurations
- **Auto-scaling architecture** with load balancing
- **Secure credential management** using AWS Secrets Manager
- **Comprehensive monitoring** with CloudWatch dashboards and alarms
- **Network isolation** with public/private subnet architecture
- **Database high availability** with Multi-AZ RDS deployment

## 🏗️ Architecture

### High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                            Internet                              │
└─────────────────────────────┬───────────────────────────────────┘
                              │
                    ┌─────────▼──────────┐
                    │  Internet Gateway   │
                    └─────────┬──────────┘
                              │
┌─────────────────────────────┴───────────────────────────────────┐
│                        VPC (10.0.0.0/16)                         │
├───────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────┐    │
│  │              Public Subnets (10.0.1-2.0/24)             │    │
│  │                                                         │    │
│  │  ┌──────────┐    ┌─────────────┐    ┌──────────┐     │    │
│  │  │   NAT    │    │     ALB      │    │   NAT    │     │    │
│  │  │Gateway-1 │    │(Load Balancer│    │Gateway-2 │     │    │
│  │  └────┬─────┘    └──────┬───────┘    └────┬─────┘     │    │
│  └───────┼─────────────────┼─────────────────┼────────────┘    │
│          │                 │                 │                  │
│  ┌───────▼─────────────────▼─────────────────▼────────────┐    │
│  │            Private Subnets (10.0.3-4.0/24)             │    │
│  │                                                         │    │
│  │  ┌─────────────────────────────────────────────┐      │    │
│  │  │         Auto Scaling Group (EC2)            │      │    │
│  │  │  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  │      │    │
│  │  │  │ EC2  │  │ EC2  │  │ EC2  │  │ EC2  │  │      │    │
│  │  │  └──────┘  └──────┘  └──────┘  └──────┘  │      │    │
│  │  └─────────────────┬───────────────────────────┘      │    │
│  │                    │                                   │    │
│  │  ┌─────────────────▼───────────────────────────┐      │    │
│  │  │          RDS MySQL (Multi-AZ)               │      │    │
│  │  │         Primary │ Standby (prod)            │      │    │
│  │  └──────────────────────────────────────────────┘      │    │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │    AWS Secrets Manager │ CloudWatch │ SNS Alerts        │   │
│  └──────────────────────────────────────────────────────────┘   │
└───────────────────────────────────────────────────────────────────┘
```
![Diagram](https://github.com/aatikah/terraform-aws-web-platform-autoscale-production/blob/main/diagram.png)

## ✨ Features

### Infrastructure Components

- **Networking**
  - Custom VPC with DNS support
  - 2 Public subnets (for ALB and NAT Gateways)
  - 2 Private subnets (for compute and database)
  - Internet Gateway for public access
  - NAT Gateways for outbound connectivity
  - Security groups with least-privilege rules

- **Compute**
  - Application Load Balancer with health checks
  - Auto Scaling Group with configurable capacity
  - Launch templates with user data automation
  - IAM roles and instance profiles
  - Session Manager access (no SSH keys needed)

- **Database**
  - RDS MySQL 8.0
  - Multi-AZ deployment (production)
  - Automated backups with configurable retention
  - Deletion protection (production)
  - Security group isolation

- **Security**
  - AWS Secrets Manager for credential management
  - Private subnet isolation for sensitive resources
  - IAM policies following least-privilege principle
  - Security group rules restricting traffic

- **Monitoring**
  - CloudWatch Dashboard for metrics visualization
  - CPU utilization alarms for auto-scaling
  - RDS performance monitoring
  - SNS notifications for critical alerts

## 📦 Prerequisites

### Required Tools

| Tool | Version | Installation |
|------|---------|-------------|
| Terraform | >= 1.0 | [Download](https://www.terraform.io/downloads) |
| AWS CLI | >= 2.0 | [Download](https://aws.amazon.com/cli/) |
| Git | Latest | [Download](https://git-scm.com/) |

### AWS Requirements

- AWS Account with appropriate permissions
- IAM user with programmatic access
- Permissions for: VPC, EC2, RDS, ALB, IAM, Secrets Manager, CloudWatch, S3

### Configure AWS CLI

```bash
aws configure
# AWS Access Key ID [None]: YOUR_ACCESS_KEY
# AWS Secret Access Key [None]: YOUR_SECRET_KEY
# Default region name [None]: us-east-1
# Default output format [None]: json
```

## 📁 Directory Structure

```
terraform-web-platform/
├── .gitignore                    # Git ignore rules
├── README.md                     # This file
├── environments/                 # Environment-specific configurations
│   ├── dev/                      # Development environment
│   │   ├── main.tf               # Main configuration calling modules
│   │   ├── variables.tf          # Variable definitions
│   │   ├── outputs.tf            # Output values
│   │   ├── provider.tf           # Provider and backend config
│   │   ├── terraform.tfvars      # Variable values
│   │   └── user_data.sh          # EC2 initialization script
│   └── prod/                     # Production environment
│       └── (similar structure)
└── modules/                      # Reusable Terraform modules
    ├── networking/               # VPC, Subnets, Security Groups
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── compute/                  # ALB, ASG, Launch Templates
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── database/                 # RDS MySQL
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── secrets/                  # AWS Secrets Manager
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── monitoring/               # CloudWatch, SNS
        ├── main.tf
        ├── variables.tf
        └── outputs.tf

```

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/aatikah/terraform-aws-web-platform-autoscale-production.git
cd terraform-web-platform
```

### 2. Create S3 Backend Bucket

```bash
# Create bucket for Terraform state
aws s3api create-bucket \
  --bucket terraform-web-platform-state-dev-account \
  --region us-east-1
```

### 3. Deploy Development Environment

```bash
# Navigate to dev environment
cd environments/dev

# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Apply configuration
terraform apply -auto-approve

```

### 4. Access the Application

```bash
# Get ALB DNS name
terraform output alb_dns_name

# Open in browser
# http://<alb-dns-name>
```

### 5. Deploy Production Environment

```bash
# Navigate to prod environment
cd ../prod

# Initialize and deploy
terraform init
terraform plan
terraform apply -auto-approve
```

## 📚 Module Descriptions

### Modules Overview

| Module | Purpose | Key Resources |
|--------|---------|--------------|
| `networking` | Network infrastructure | VPC, Subnets, IGW, NAT, Security Groups |
| `compute` | Application servers | ALB, ASG, Launch Template, IAM |
| `database` | Data persistence | RDS MySQL, Subnet Group |
| `secrets` | Credential management | Secrets Manager, Random Password |
| `monitoring` | Observability | CloudWatch Dashboard, Alarms, SNS |


### Module Inputs and Outputs

#### Networking Module

**Inputs:**
- `environment` - Environment name (dev/prod)
- `vpc_cidr` - CIDR block for VPC
- `public_subnet_cidrs` - List of public subnet CIDRs
- `private_subnet_cidrs` - List of private subnet CIDRs
- `availability_zones` - List of AZs to use

**Outputs:**
- `vpc_id` - VPC identifier
- `public_subnet_ids` - List of public subnet IDs
- `private_subnet_ids` - List of private subnet IDs
- `alb_security_group_id` - Security group for ALB
- `web_security_group_id` - Security group for web servers
- `database_security_group_id` - Security group for RDS

#### Compute Module

**Inputs:**
- `environment` - Environment name
- `vpc_id` - VPC identifier
- `public_subnet_ids` - Public subnets for ALB
- `private_subnet_ids` - Private subnets for EC2
- `instance_type` - EC2 instance type
- `min_size` - Minimum ASG size
- `max_size` - Maximum ASG size
- `desired_capacity` - Desired ASG capacity

**Outputs:**
- `alb_dns_name` - Load balancer DNS name
- `asg_name` - Auto Scaling Group name

## 🔧 Environment Configurations

### Development Environment

```hcl
# environments/dev/main.tf
module "compute" {
  source = "../../modules/compute"
  
  environment      = "dev"
  instance_type    = "t2.micro"
  min_size         = 2
  max_size         = 4
  desired_capacity = 2
}

module "database" {
  source = "../../modules/database"
  
  environment                = "dev"
  database_instance_class    = "db.t3.micro"
  database_allocated_storage = 20
  skip_final_snapshot        = true
  deletion_protection        = false
  backup_retention_period    = 0
}
```

### Production Environment

```hcl
# environments/prod/main.tf
module "compute" {
  source = "../../modules/compute"
  
  environment      = "prod"
  instance_type    = "t3.medium"
  min_size         = 3
  max_size         = 10
  desired_capacity = 3
}

module "database" {
  source = "../../modules/database"
  
  environment                = "prod"
  database_instance_class    = "db.t3.small"
  database_allocated_storage = 100
  skip_final_snapshot        = false
  deletion_protection        = true
  backup_retention_period    = 14
}
```

### Environment Comparison

| Feature | Development | Production |
|---------|------------|------------|
| EC2 Instance Type | t2.micro | t3.medium |
| Min ASG Size | 2 | 3 |
| Max ASG Size | 4 | 10 |
| RDS Instance Class | db.t3.micro | db.t3.small |
| RDS Storage | 20 GB | 100 GB |
| Multi-AZ RDS | No | Yes |
| Deletion Protection | No | Yes |
| Backup Retention | 0 days | 14 days |
| ALB Deletion Protection | No | Yes |

## 🔐 Security

### Security Features Implemented

1. **Network Security**
   - Private subnets for sensitive resources
   - Security groups with minimal required access
   - NACLs for additional network protection

2. **Secrets Management**
   - AWS Secrets Manager for database credentials
   - No hardcoded passwords in code
   - Automatic password rotation capability

3. **IAM Security**
   - Least-privilege IAM policies
   - Instance profiles for EC2 access
   - Service-specific roles

4. **Data Protection**
   - RDS encryption at rest (optional)
   - SSL/TLS for data in transit
   - Backup encryption

### Security Group Rules

```hcl
# ALB Security Group
Ingress: 80/tcp from 0.0.0.0/0
Ingress: 443/tcp from 0.0.0.0/0
Egress: All

# Web Security Group
Ingress: 80/tcp from ALB SG
Ingress: 22/tcp from 0.0.0.0/0 (restrict in production)
Egress: All

# Database Security Group
Ingress: 3306/tcp from Web SG
Egress: All
```

## 📊 Monitoring & Alerts

### CloudWatch Dashboard Widgets

1. **EC2 Metrics**
   - CPU Utilization
   - Network In/Out
   - Disk Read/Write

2. **RDS Metrics**
   - CPU Utilization
   - Database Connections
   - Free Storage Space
   - Freeable Memory

3. **ALB Metrics**
   - Request Count
   - Target Response Time
   - HTTP 4xx/5xx Errors
   - Healthy Host Count

### Configured Alarms

| Alarm | Metric | Threshold | Action |
|-------|--------|-----------|--------|
| High CPU (ASG) | CPUUtilization | > 70% for 2 periods | Scale Up |
| Low CPU (ASG) | CPUUtilization | < 30% for 2 periods | Scale Down |
| RDS High CPU | CPUUtilization | > 80% for 2 periods | SNS Alert |
| RDS Low Storage | FreeStorageSpace | < 5GB | SNS Alert |


## 💰 Cost Optimization

### Implemented Optimizations

1. **Auto-scaling** - Scale down during low traffic
2. **Right-sizing** - Environment-appropriate instance sizes
3. **Reserved Instances** - For production workloads
4. **Scheduled Scaling** - Reduce capacity during off-hours


### Estimated Monthly Costs

| Environment | Compute | Database | Network | Storage | Total |
|-------------|---------|----------|---------|---------|-------|
| Development | $30 | $15 | $20 | $5 | ~$70 |
| Production | $150 | $50 | $40 | $20 | ~$260 |

*Note: Costs are estimates and vary by region and usage*


## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

### Development Setup

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run validation:
   ```bash
   # Format code
   terraform fmt -recursive
   
   # Validate configuration
   terraform validate
  
   ```
5. Commit changes (`git commit -m 'Add amazing feature'`)
6. Push to branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Coding Standards

- Use meaningful resource names
- Add descriptions to all variables
- Include outputs for important values
- Comment complex logic
- Follow [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/)


## 📄 License

This project is licensed under the MIT License. Feel free to use and modify it.

## 📖 Detailed Walkthrough
For a comprehensive step-by-step guide, including screenshots and detailed explanations, check out the full tutorial on Medium:
[**Building a Production-Ready Auto-Scaling Web Platform on AWS with Terraform: A Complete Implementation Guide**](https://medium.com/p/2d25df7fce81?sk=30c755cbf1cb5a97ba9643cfd97b2e04)

**Note**: Remember to customize the repository URLs, AWS account IDs, and other project-specific details before using in production.

## 📬 Connect With Me
- 💼 [LinkedIn](https://www.linkedin.com/in/abdulhakeem-sulaiman/)
- ☕ [Support me on BuyMeACoffee](https://buymeacoffee.com/aatikah)
- 🧪 [Explore More Projects on GitHub](https://github.com/aatikah)

