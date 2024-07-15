# CloudDevOps
# Udacity Module2 - IAC:- Submission on 14th July

Please Note: 
1. Udagram is split based on resources - I am in progress with creating udagram.ym & udagram-parameters.json by grouping these. Will submit this project once again

Completed Steps in Brief: 
1. Create Networking Stack - VPC, 2 Private & 2 Public Subnets, NAT Gateway, IGW, Route Table to attach with NAT & IGW 
./deploy.sh

2. Udagram : Create ALB Configuration
./deploy-alb.sh

Output: 
Target Group ARN: arn:aws:elasticloadbalancing:us-east-1:387581210505:targetgroup/myTargetGroup/8dc8b3d9f5845b65

Load Balancer DNS: http://myLoadBalancer-651537923.us-east-1.elb.amazonaws.com

4. Udagram : Create ASG Instances
./deploy-asg.sh

5. Udagram: Create S3 & IAM
./deploy-s3.sh

6. Udagram: Create SGs
./deploy-sg.sh


