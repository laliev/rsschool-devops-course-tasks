resource "aws_dynamodb_table" "tf_lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST" # no capacity planning
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  # Optional but recommended – point-in-time recovery
  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name        = "terraform-state-lock"
    Environment = "dev"
  }
}
