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
