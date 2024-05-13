## Prod
resource "aws_s3_bucket" "backend_prod" {
  bucket = "project-x-stat-bucket-prod"

  tags = {
    Name        = "terraform-state-for-project-x-prod"
    Environment = "prod"
  }
}

#resource "aws_s3_bucket_versioning" "versioning_example" {
#  bucket = aws_s3_bucket.backend_dev.id
#  versioning_configuration {
#    status = "Enabled"
#  }
#}

resource "aws_dynamodb_table" "basic_dynamodb_table_prod" {
  name         = "terraform-dynamodb-lock-table-prod"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name        = "terraform-dynamodb-lock-table-prod"
    Environment = "prod"
  }
}
