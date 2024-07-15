#!/bin/bash

# Function to delete stack if it exists
delete_stack_if_exists() {
    stack_name=$1
    stack_exists=$(aws cloudformation describe-stacks --stack-name $stack_name 2>&1)

    if [ $? -eq 0 ]; then
        echo "Deleting existing stack: $stack_name"
        aws cloudformation delete-stack --stack-name $stack_name
        aws cloudformation wait stack-delete-complete --stack-name $stack_name
    fi
}

# Parameters
BUCKET_NAME="my-bkt-13072200"

delete_stack_if_exists s3-bucket-stack
delete_stack_if_exists iam-role-stack

aws cloudformation create-stack --stack-name s3-bucket-stack --template-body file://s3.yml --parameters ParameterKey=BucketName,ParameterValue=$BUCKET_NAME
aws cloudformation wait stack-create-complete --stack-name s3-bucket-stack

if [ $? -eq 0 ]; then
    echo "S3 bucket created successfully."
else
    echo "Failed to create S3 bucket stack"
    exit 1
fi

aws cloudformation create-stack --stack-name iam-role-stack --template-body file://iam.yml --parameters ParameterKey=BucketName,ParameterValue=$BUCKET_NAME --capabilities CAPABILITY_IAM
aws cloudformation wait stack-create-complete --stack-name iam-role-stack

if [ $? -eq 0 ]; then
    echo "IAM Role created successfully with S3 permissions."
else
    echo "Failed to create IAM Role stack"
    exit 1
fi
