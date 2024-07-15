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
PRIVATE_SUBNETS=$(aws cloudformation describe-stacks --stack-name networking-stack --query "Stacks[0].Outputs[?OutputKey=='PrivateSubnets'].OutputValue" --output text)
TARGET_GROUP_ARN=$(aws cloudformation describe-stacks --stack-name load-balancer-stack --query "Stacks[0].Outputs[?OutputKey=='TargetGroupARN'].OutputValue" --output text)
echo "VPC_ID ------------$VPC_ID"
echo "PUBLIC_SUBNETS ----$PUBLIC_SUBNETS"
echo "TARGET_GROUP_ARN ----$TARGET_GROUP_ARN"

if [ -z "$VPC_ID" ] || [ -z "$PRIVATE_SUBNETS" ] || [ -z "$TARGET_GROUP_ARN" ]; then
    echo "Error: Could not fetch parameters from stacks"
    exit 1
fi

delete_stack_if_exists autoscaling-stack

aws cloudformation create-stack --stack-name autoscaling-stack --template-body file://asg.yml --parameters ParameterKey=VpcId,ParameterValue=$VPC_ID ParameterKey=PrivateSubnets,ParameterValue=\"$PRIVATE_SUBNETS\" ParameterKey=TargetGroupARN,ParameterValue=$TARGET_GROUP_ARN --capabilities CAPABILITY_IAM
aws cloudformation wait stack-create-complete --stack-name autoscaling-stack

if [ $? -eq 0 ]; then
    echo "Auto Scaling Group and Launch Template created successfully."
else
    echo "Failed to create autoscaling stack"
fi
