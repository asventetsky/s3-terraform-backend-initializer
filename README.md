# S3 Terraform backend initializer

S3 Terraform backend initializer is a tool for dealing with AWS resources (S3 and DynamoDB).
## Prerequisites

### Create and configure AWS User
The AWS user should be created and configured with such a policy:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:CreateBucket",
        "s3:PutBucketVersioning",
        "s3:PutEncryptionConfiguration",
        "s3:PutBucketTagging",
        "s3:ListBucketVersions",
        "s3:DeleteObjectVersion",
        "s3:DeleteObject",
        "s3:DeleteBucket",
        "dynamodb:CreateTable",
        "dynamodb:TagResource",
        "dynamodb:DeleteTable"
      ],
      "Resource": "*"
    }
  ]
}
```

### (Optional) Set AWS access key and AWS secret key
The next step is to set the corresponding secrets in order to run AWS CLI commands (Settings -> Secrets and variables -> Actions):
`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.


## Usage

There are two workflows you can use:
- Init S3 Terraform backend
- Remove S3 Terraform backend

Both workflow accepts several variables:
- AWS Region (required)
- AWS S3 Bucket Name (required)
- AWS DynamoDB Table Name (optional, if you don't want to create a lock table)
- AWS access key id (optional, if secret `AWS_ACCESS_KEY_ID` has been created)
- AWS secret access key (optional, if secret `AWS_SECRET_ACCESS_KEY` has been created)

Provide the required values and run the workflow.
