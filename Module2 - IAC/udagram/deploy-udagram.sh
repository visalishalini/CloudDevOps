#!/bin/bash

delete_stack_if_exists() {
    stack_name=$1
    stack_exists=$(aws cloudformation describe-stacks --stack-name $stack_name 2>&1)

    if [ $? -eq 0 ]; then
        echo "Deleting existing stack: $stack_name"
        aws cloudformation delete-stack --stack-name $stack_name
        aws cloudformation wait stack-delete-complete --stack-name $stack_name
    fi
}

VPC_ID=$(aws cloudformation describe-stacks --stack-name networking-stack --query "Stacks[0].Outputs[?OutputKey=='VPCID'].OutputValue" --output text)
PUBLIC_SUBNETS=$(aws cloudformation describe-stacks --stack-name networking-stack --query "Stacks[0].Outputs[?OutputKey=='PublicSubnets'].OutputValue" --output text)
PRIVATE_SUBNETS=$(aws cloudformation describe-stacks --stack-name networking-stack --query "Stacks[0].Outputs[?OutputKey=='PrivateSubnets'].OutputValue" --output text)
BUCKET_NAME="my-bkt-13072200"
echo "VPC_ID ------------$VPC_ID"
echo "PUBLIC_SUBNETS ----$PUBLIC_SUBNETS"
echo "PUBLIC_SUBNETS ----$PRIVATE_SUBNETS"


if [ -z "$VPC_ID" ] || [ -z "$PUBLIC_SUBNETS" ] || [ -z "$PRIVATE_SUBNETS" ]; then
    echo "Error: Could not fetch parameters from stacks"
    exit 1
fi

delete_stack_if_exists udagram-stack

echo "Creating load-balancer-stack: Configuring ALB & fetching ALB http url....."
aws cloudformation create-stack --stack-name udagram-stack --template-body file://udagram.yml --parameters ParameterKey=VpcId,ParameterValue=$VPC_ID ParameterKey=PrivateSubnets,ParameterValue=\"$PRIVATE_SUBNETS\" ParameterKey=PublicSubnets,ParameterValue=\"$PUBLIC_SUBNETS\" ParameterKey=BucketName,ParameterValue=$BUCKET_NAME --capabilities CAPABILITY_IAM
aws cloudformation wait stack-create-complete --stack-name udagram-stack

if [ $? -eq 0 ]; then
    echo "Udagram infra created successfully."
else
    echo "Failed to create udagram stack"
fi
