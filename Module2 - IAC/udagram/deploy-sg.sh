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
echo "VPC_ID ------------$VPC_ID"

# Check if VPC_ID parameter is fetched successfully
if [ -z "$VPC_ID" ]; then
    echo "Error: Could not fetch VPC_ID parameter from networking stack"
    exit 1
fi

delete_stack_if_exists security-groups-stack

aws cloudformation create-stack --stack-name security-groups-stack --template-body file://sg.yml --parameters ParameterKey=VpcId,ParameterValue=$VPC_ID
aws cloudformation wait stack-create-complete --stack-name security-groups-stack

if [ $? -eq 0 ]; then
    echo "Security Groups created successfully."
else
    echo "Failed to create security groups stack"
fi
