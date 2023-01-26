#!/bin/bash

main() {
  # parse flags
  while getopts "r:s:d:" flag; do
    case "${flag}" in
      r) REGION=${OPTARG};;
      s) S3_BUCKET_NAME=${OPTARG};;
      d) DYNAMO_DB_TABLE_NAME=${OPTARG};;
      \?) echo "Unknown flag, available flags are -r, -s and -d"; exit;;
    esac
  done

  print_flag_values
  create_and_configure_s3_bucket
  if [[ -n $DYNAMO_DB_TABLE_NAME ]]; then
    create_dynamo_db_table
  fi
}

print_flag_values() {
  echo "Region: $REGION"
  echo "S3 Bucket Name: $S3_BUCKET_NAME"
  echo "DynamoDB table name: $DYNAMO_DB_TABLE_NAME"
}

create_and_configure_s3_bucket() {
  create_s3_bucket
  enable_s3_bucket_versioning
  enable_s3_bucket_encryption
  add_s3_bucket_tags
}

create_s3_bucket() {
  echo "Start creating S3 bucket."
  aws s3api create-bucket \
    --bucket "$S3_BUCKET_NAME" \
    --region "$REGION" \
    --create-bucket-configuration LocationConstraint="$REGION" \
    || exit
  echo "Finish creating S3 bucket."
}

enable_s3_bucket_versioning() {
  echo "Start enabling versioning for S3 bucket."
  aws s3api put-bucket-versioning \
    --bucket "$S3_BUCKET_NAME" \
    --versioning-configuration MFADelete=Disabled,Status=Enabled \
    || exit
  echo "Finish enabling versioning for S3 bucket."
}

enable_s3_bucket_encryption() {
  echo "Start enabling encryption for S3 bucket."
  aws s3api put-bucket-encryption \
    --bucket "$S3_BUCKET_NAME" \
    --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}' \
    || exit
  echo "Finish enabling encryption for S3 bucket."
}

add_s3_bucket_tags() {
  echo "Start adding tags for S3 bucket."
  aws s3api put-bucket-tagging \
    --bucket "$S3_BUCKET_NAME" \
    --tagging 'TagSet=[{Key=CreatedBy,Value=https://github.com/asventetsky/s3-terraform-backend-initializer}]' \
    || exit
  echo "Finish adding tags for S3 bucket."
}

create_dynamo_db_table() {
  echo "Start creating DynamoDB table."
  aws dynamodb create-table \
    --table-name "$DYNAMO_DB_TABLE_NAME" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
    --tags Key=CreatedBy,Value=https://github.com/asventetsky/s3-terraform-backend-initializer \
    || exit
  echo "Finish creating DynamoDB table."
}

main "$@"; exit
