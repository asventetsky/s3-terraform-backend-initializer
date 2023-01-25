# S3 Terraform backend initializer

S3 Terraform backend initializer is a tool for dealing with AWS resources (S3 and DynamoDB).

## Usage
```shell
./init.sh -r eu-central-1 -s history-proj-ffdsfji4u43ujfkdjf -d history-proj-fsaffsf43v4f

-f - AWS Region
-s - AWS S3 Bucket Name
-d - AWS DynamoDB Table Name
```

If you don't want to create a lock table, just omit `-d` flag and value.