variable "region" {
  type = string
  description = "AWS Region"
}

variable "s3_bucket_name" {
  type = string
  description = "AWS S3 bucket name for storing remote state"
}

variable "dynamo_db_table_name" {
  type = string
  default = null
  description = "AWS DynamoDB table name for locking"
}