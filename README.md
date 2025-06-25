
- **Public subnets** receive public IPs and host the Bastion and (optionally) NAT gateways.  
- **Private subnets** have no public IPs; their default route points to the NAT gateway.  
- **Security Groups & NACLs** restrict traffic to best-practice minimums.

---

## File Layout

| File | Purpose |
|------|---------|
| `backend.tf` | Remote-state backend (S3 + DynamoDB lock). |
| `variables.tf` | All input variables with sane defaults. |
| `network.tf` | VPC, subnets, route tables, IGW, NAT. |
| `compute.tf` | Bastion host, SSH key pair, security groups. |
| `github_actions_role.tf` | OIDC provider + IAM role for GitHub Actions. |
| `.github/workflows/terraform.yml` | CI pipeline (fmt → validate → plan → apply). |
| `screens/` | Screenshots (`terraform plan`, AWS resource map). |

---

## Prerequisites

| Tool | Minimum version |
|------|-----------------|
| Terraform | 1.4 + |
| AWS CLI   | 2.x |
| AWS account creds with permission to create VPC, EC2, IAM, S3, DynamoDB |

 