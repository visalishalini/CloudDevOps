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
echo "VPC_ID ------------$VPC_ID"
echo "PUBLIC_SUBNETS ----$PUBLIC_SUBNETS"

if [ -z "$VPC_ID" ] || [ -z "$PUBLIC_SUBNETS" ]; then
    echo "Error: Could not fetch parameters from stacks"
    exit 1
fi

delete_stack_if_exists load-balancer-stack

aws cloudformation create-stack --stack-name load-balancer-stack --template-body file://alb.yml --parameters ParameterKey=VpcId,ParameterValue=$VPC_ID ParameterKey=PublicSubnets,ParameterValue=\"$PUBLIC_SUBNETS\" --capabilities CAPABILITY_IAM
aws cloudformation wait stack-create-complete --stack-name load-balancer-stack

if [ $? -eq 0 ]; then
    TARGET_GROUP_ARN=$(aws cloudformation describe-stacks --stack-name load-balancer-stack --query "Stacks[0].Outputs[?OutputKey=='TargetGroupARN'].OutputValue" --output text)
    echo "Target Group ARN: $TARGET_GROUP_ARN"
    echo "Load Balancer DNS: $(aws cloudformation describe-stacks --stack-name load-balancer-stack --query "Stacks[0].Outputs[?OutputKey=='LoadBalancerDNSName'].OutputValue" --output text)"
else
    echo "Failed to create load balancer stack"
fi
