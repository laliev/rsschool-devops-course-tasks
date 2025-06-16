# backend.tf
terraform {
  backend "s3" {
    bucket         = "tfstate-165090876640-eu-central-1"
    key            = "global/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = var.aws_region # var.aws_region is still OK here
}
