# AWS / Terraform Playground  

A tiny setup for the RS School DevOps course.  
Everything is managed with **Terraform**, and a GitHub Actions pipeline keeps it up to date.

---

## What it spins up

| Resource | Why it exists |
|----------|---------------|
| **S3 bucket** `tfstate-<account>-eu-central-1` | Stores the Terraform state file (versioned, encrypted) |
| **DynamoDB table** `terraform-state-lock` | Prevents two people from touching the state at once |
| **IAM role** `GithubActionsRole` | Used by the CI pipeline—assumed via OIDC, no static keys |
| **OIDC provider** for `token.actions.githubusercontent.com` | Lets GitHub prove its identity to AWS |

---

## Prerequisites

* Terraform ≥ 1.5  
* AWS CLI v2 (configured with a user that can create S3 / DynamoDB / IAM stuff)  
* Git

---

## First run

```bash
git clone https://github.com/laliev/rsschool-devops-course-tasks.git
cd rsschool-devops-course-tasks

terraform init -reconfigure     # sets up the S3 backend
terraform plan                  # have a look first
terraform apply                 # creates everything
