resource "aws_s3_bucket" "remote_state_bucket" {

  bucket = var.s3_bucket_name

  tags = {
    Terraform = "true"
  }
}

resource "aws_s3_bucket_versioning" "remote_state_bucket_version" {

  bucket = aws_s3_bucket.remote_state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "remote_state_bucket_" {

  bucket = aws_s3_bucket.remote_state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "remote_state_lock_table" {

  name           = var.dynamo_db_table_name
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Terraform = "true"
  }
}

