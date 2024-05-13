## Staging
resource "aws_s3_bucket" "backend_staging" {
  bucket = "project-x-stat-bucket-staging"

  tags = {
    Name        = "terraform-state-for-project-x-staging"
    Environment = "staging"
  }
}

#resource "aws_s3_bucket_versioning" "versioning_example" {
#  bucket = aws_s3_bucket.backend_dev.id
#  versioning_configuration {
#    status = "Enabled"
#  }
#}

resource "aws_dynamodb_table" "basic_dynamodb_table_staging" {
  name         = "terraform-dynamodb-lock-table-staging"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name        = "terraform-dynamodb-lock-table-staging"
    Environment = "staging"
  }
}
