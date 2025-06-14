resource "aws_s3_bucket" "tfstate" {
  bucket        = "tfstate-${data.aws_caller_identity.current.account_id}-${var.aws_region}"
  force_destroy = false                      # keep state files safe

  # Enable bucket versioning
  versioning {
    enabled = true
  }

  # Default server-side encryption (AES-256)
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true                  # extra guard against deletion
  }

  tags = {
    Name        = "tfstate"
    Environment = "dev"
  }
}

data "aws_caller_identity" "current" {}
