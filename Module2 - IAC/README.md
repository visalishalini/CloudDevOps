# CloudDevOps
Udacity Module1 - AWS Cloud Fundamentals Assignments

Steps for which screenshot has been shared
Step1: S3 bucket is created
Step2: The static website related files & folders have been uploaded to the bucket
Step3: S3 Bucket has been configured for static website hosting. Endpoint shared in screenshot below:
Step4: S3 Bucket IAM Policy & Permissions (Screenshot taken After CloudFront Distribution):
Step5: Cloudfront has been created :
Step6:  Cloudfront configuration with domain name
Step7: Web Browser Access using Cloudfront domain name endpoint and static website hosting bucket endpoints
Cloudfront Distribution Domain Name: d2hhk65baiidm8.cloudfront.net

# Udacity Module1- Resubmission on 18June 
Steps for which screenshot has been shared
Step1: S3 bucket is created
Step2: The static website related files & folders have been uploaded to the bucket
Step3: S3 Bucket has been configured for static website hosting. Endpoint shared in screenshot below:
Step4: S3 Bucket IAM Policy & Permissions (Screenshot taken After CloudFront Distribution):
Step5: Cloudfront has been created :
Step6:  Cloudfront configuration with domain name
Step7: Web Browser Access using Cloudfront domain name endpoint and static website hosting bucket endpoints

URLS with which the Travel Blog was accessed as per screenshot:
1) CloudFront: http://duej1tr6q0p2v.cloudfront.net
2) Static Website endpoint: http://test-awss3-bucket.s3-website.us-east-1.amazonaws.com/
3) Static Website endpoint: http://test-awss3-bucket.s3-website-us-east-1.amazonaws.com/
4) Bucket url for index.html : https://test-awss3-bucket.s3.amazonaws.com/index.html

# Udacity Module2 - IAC:- Submission on 14th July

Please Note: 
1) Udagram is split based on resources - I am in progress with creating udagram.ym & udagram-parameters.json by grouping these. Will submit this project once again

Completed Steps in Brief: 
Step1: Create Networking Stack - VPC, 2 Private & 2 Public Subnets, NAT Gateway, IGW, Route Table to attach with NAT & IGW 
./deploy.sh

Step2: Udagram : Create ALB Configuration
./deploy-alb.sh
Output: 
Target Group ARN: arn:aws:elasticloadbalancing:us-east-1:387581210505:targetgroup/myTargetGroup/8dc8b3d9f5845b65
Load Balancer DNS: http://myLoadBalancer-651537923.us-east-1.elb.amazonaws.com

Step3: Udagram : Create ASG Instances
./deploy-asg.sh

Step4: Udagram: Create S3 & IAM
./deploy-s3.sh

Step5: Udagram: Create SGs
./deploy-sg.sh


