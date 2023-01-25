# S3 Terraform backend initializer

S3 Terraform backend initializer is a tool for dealing with AWS resources (S3 and DynamoDB).

## Usage
```shell
./init.sh -r <region> -s <bucket_name> -d <table_name>

-f - AWS Region
-s - AWS S3 Bucket Name
-d - AWS DynamoDB Table Name
```

If you don't want to create a lock table, just omit `-d` flag and value.