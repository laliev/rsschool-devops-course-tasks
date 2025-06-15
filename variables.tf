variable "aws_region" {
  description = "AWS region for provider and backend"
  type        = string
  default     = "eu-central-1"
}

variable "github_repository" {
  description = "GitHub repository in owner/repo format"
  type        = string
  default     = "laliev/rsschool-devops-course-tasks"
}


variable "instance_type" {
  description = "EC2 instance type for the lab host"
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "Name of the SSH key pair to use"
  type        = string
  default     = "rs-school-key"
}

variable "my_ip" {
  description = "CIDR of your public IP for SSH access"
  type        = string
  default     = "0.0.0.0/0" # change later to your real IP/CIDR
}