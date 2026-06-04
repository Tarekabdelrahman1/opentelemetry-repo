provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "demo-terraform-eks-state-s3-tarek-bucket"

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-eks-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}