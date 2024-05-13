# ### Dev
resource "aws_s3_bucket" "backend_dev" {
  bucket = "project-x-stat-bucket-ilya-dev"

  tags = {
    Name        = "terraform-state-for-project-x-ilya-dev"
    Environment = "dev"
  }
}

# resource "aws_s3_bucket_versioning" "versioning_example" {
#  bucket = aws_s3_bucket.backend_dev.id
#  versioning_configuration {
#    status = "Enabled"
#  }
# }

resource "aws_dynamodb_table" "basic_dynamodb_table_dev" {
  name         = "terraform-dynamodb-lock-table-dev"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name        = "terraform-dynamodb-lock-table-dev"
    Environment = "dev"
  }
}
