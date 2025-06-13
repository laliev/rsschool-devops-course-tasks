##############################
# Input variables
##############################

variable "aws_region" {
  description = "Default AWS region for provider and S3 backend"
  type        = string
  default     = "eu-central-1"
}

variable "github_repository" {
  description = "GitHub repository in owner/repo format"
  type        = string
  default     = "laliev/rsschool-devops-course-tasks"
}
