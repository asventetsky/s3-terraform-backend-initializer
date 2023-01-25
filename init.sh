#!/bin/bash

# parse flags
while getopts "r:s:d:" flag; do
    case "${flag}" in
        r) REGION=${OPTARG};;
        s) S3_BUCKET_NAME=${OPTARG};;
        d) DYNAMO_DB_TABLE_NAME=${OPTARG};;
       \?) echo "Unknown flag, available flags are -r, -s and -d"; exit;;
    esac
done

# print flags' values
echo "Region: $REGION"
echo "S3 Bucket Name: $S3_BUCKET_NAME"
echo "DynamoDB table name: $DYNAMO_DB_TABLE_NAME"

cd src || exit

# init terraform
terraform init

# apply terraform
if [[ -z $DYNAMO_DB_TABLE_NAME ]]; then
  terraform apply -var "region=$REGION" -var "s3_bucket_name=$S3_BUCKET_NAME" --auto-approve
else
  terraform apply -var "region=$REGION" -var "s3_bucket_name=$S3_BUCKET_NAME" -var "dynamo_db_table_name=$DYNAMO_DB_TABLE_NAME" --auto-approve

fi

# clear local files and folders
rm -rf .terraform/
rm -rf .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup