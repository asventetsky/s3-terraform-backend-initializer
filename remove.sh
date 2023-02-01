#!/bin/bash

main() {
  # parse flags
  while getopts "r:b:t:a:s:" flag; do
    case "${flag}" in
      r) REGION=${OPTARG};;
      b) S3_BUCKET_NAME=${OPTARG};;
      t) DYNAMO_DB_TABLE_NAME=${OPTARG};;
      a) ACCESS_KEY_ID=${OPTARG};;
      s) SECRET_ACCESS_KEY=${OPTARG};;
      \?) echo "Unknown flag, available flags are -r, -s and -d"; exit;;
    esac
  done

  print_flag_values
  set_aws_keys
  remove_s3_bucket
  if [[ -n $DYNAMO_DB_TABLE_NAME ]]; then
    remove_dynamo_db_table
  fi
}

print_flag_values() {
  echo "Region: $REGION"
  echo "S3 Bucket Name: $S3_BUCKET_NAME"
  echo "DynamoDB table name: $DYNAMO_DB_TABLE_NAME"
}

set_aws_keys() {
  if [[ -n $ACCESS_KEY_ID && -n $SECRET_ACCESS_KEY ]]; then
    export AWS_ACCESS_KEY_ID=$ACCESS_KEY_ID
    export AWS_SECRET_ACCESS_KEY=$SECRET_ACCESS_KEY
    echo "Using AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY from inputs"
  else
    echo "Using AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY from secrets"
  fi
}

remove_s3_bucket() {
  aws s3api delete-objects \
    --bucket "$S3_BUCKET_NAME" \
    --delete "$(aws s3api list-object-versions \
    --bucket "$S3_BUCKET_NAME" \
    --output=json \
    --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}')"

  aws s3 rb "s3://$S3_BUCKET_NAME"
}

remove_dynamo_db_table() {
  aws dynamodb delete-table \
    --table-name "$DYNAMO_DB_TABLE_NAME"
}

main "$@"; exit