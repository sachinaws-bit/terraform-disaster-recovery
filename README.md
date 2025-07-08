
# 🛡️ Terraform-Based Disaster Recovery (DR) Infrastructure on AWS

## 📍 Table of Contents

1. [Introduction](#1-introduction)  
2. [Project Overview](#2-project-overview)  
3. [Infrastructure Design Principles](#3-infrastructure-design-principles)  
4. [Overall Architecture](#4-overall-architecture)  
5. [Terraform Deployment](#5-terraform-deployment)  
6. [Global Traffic Management (Route 53)](#6-global-traffic-management-route-53)  
7. [Monitoring & Alerting](#7-monitoring--alerting)  
8. [Security Best Practices](#8-security-best-practices)  
9. [Author](#9-author)  
10. [Final Notes](#10-final-notes)  

---

## 1. Introduction

This project implements a **Disaster Recovery (DR)** solution using **Terraform** to provision and replicate infrastructure across two AWS regions in a warm standby mode.

---

## 2. Project Overview

### 🧱 Modules Used:
- **Networking:** VPCs and subnets in primary and DR regions
- **Security:** Security Groups per region
- **Compute:** EC2 instances as primary and warm standby
- **Load Balancer:** ALBs in both regions
- **Database:** RDS with read replica in DR region
- **Replication:** S3 cross-region replication
- **Monitoring:** CloudWatch alarms
- **Failover:** Route 53 health checks with DNS failover

---

## 3. Infrastructure Design Principles

| Goal               | Strategy                                                                 |
|--------------------|--------------------------------------------------------------------------|
| High Availability  | Multi-AZ setup, Route 53 regional failover                               |
| Fault Tolerance    | Redundant compute, ALB and RDS replicas                                  |
| Scalability        | Load Balancers and subnet design to allow scaling                        |
| DR Readiness       | Warm standby instances and failover DNS setup                            |

---

## 4. Overall Architecture

```
                       🌐 Internet
                            |
                       [ Route 53 ]
                     /               \
     📍 us-east-1 (Primary)     📍 us-east-2 (DR)
     --------------------       ---------------------
     [  ALB  ]                  [  ALB  ]
         |                         |
    [ EC2 + RDS ]            [ EC2 + Read Replica ]
         |                         |
    [ S3 (with CRR) ]       [ S3 Replica ]
```

---

## 5. Terraform Deployment

### 💡 Deployment Steps

```bash
git clone https://github.com/<your-username>/terraform-disaster-recovery.git
cd terraform-disaster-recovery
terraform init
terraform plan
terraform apply
```

> Remote backend (S3 + DynamoDB) is used for state locking and consistency.

---

## 6. Global Traffic Management (Route 53)

### 🧠 Failover DNS Record Setup

| Record Type | Region     | Role     | Health Check |
|-------------|------------|----------|--------------|
| A (Alias)   | us-east-1  | PRIMARY  | ✅ Enabled   |
| A (Alias)   | us-east-2  | SECONDARY| ✅ Enabled   |

---

## 7. Monitoring & Alerting

🔔 **CloudWatch Alarms** are configured for EC2 CPU utilization:

- Primary CPU > 80%
- DR CPU > 80%

> You can extend this to SNS, Slack, etc.

---

## 8. Security Best Practices

- Principle of Least Privilege IAM policies
- RDS is private and non-publicly accessible
- Security Groups allow only HTTP (80) and SSH (22)
- S3 buckets have versioning and replication enabled

---

## 9. Author

👨‍💻 **Sachin Sharma**  
GitHub: [@sachinaws-bit](https://github.com/sachinaws-bit)

---

## 10. Final Notes

✅ Multi-region warm standby DR infrastructure  
🔁 Route 53 failover routing based on ALB health checks  
⚙️ Infrastructure-as-Code using Terraform  
📊 Built-in monitoring and alerting

---

## 📁 Repository Structure

```
terraform-disaster-recovery/
├── backend.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── terraform.tfvars (optional)
├── modules/
│   ├── networking/
│   ├── security/
│   ├── compute/
│   ├── load-balancer/
│   ├── database/
│   ├── replication/
│   ├── monitoring/
│   └── dr-failover/
└── README.md
```

---

## 🧾 .gitignore Example

```
.terraform/
*.tfstate
*.tfvars
crash.log
.terraform.lock.hcl
.idea/
.vscode/
.DS_Store
```
