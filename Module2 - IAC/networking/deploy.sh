#!/bin/bash

# Deploy networking stack
aws cloudformation create-stack --stack-name networking-stack --template-body file://networking.yml --parameters file://network-parameters.json --capabilities CAPABILITY_IAM
aws cloudformation wait stack-create-complete --stack-name networking-stack
