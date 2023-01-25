# S3 Terraform backend initializer

S3 Terraform backend initializer is a tool for dealing with AWS resources (S3 and DynamoDB).

## Usage
Init terraform:
```shell
terraform init
```
And finally invoke resources creation:
```shell
terraform apply -var 'region=<region>' -var 's3_bucket_name=<s3_bucket_name>' -var 'dynamo_db_table_name=<dynamo_db_table_name>'
```

If you don't want to create a lock table, just omit `dynamo_db_table_name` variable.