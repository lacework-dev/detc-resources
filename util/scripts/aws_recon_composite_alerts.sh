#!/bin/bash

# Account recon work - should trigger potential stolen credentials composite alert
aws sts get-caller-identity || true
aws iam get-user || true
aws iam list-account-aliases || true
aws iam list-users || true
aws iam list-groups || true
aws iam list-roles || true
aws configure list-profiles || true
aws s3api list-buckets --output json || true
aws s3 ls || true
aws ssm list-commands || true
aws ssm list-documents || true
aws ssm list-tags-for-resource || true
aws ssm list-command-invocations || true
aws iam list-attached-group-policies --group-name Production || true

regions=("us-east-1" "us-east-2" "us-west-2" "ap-south-1" "eu-west-2" "eu-north-1")
rand=$[$RANDOM % ${#regions[@]}]
region=${regions[rand]}
echo "region $rand ${region}"

export AWS_DEFAULT_REGION=${region}
aws sts get-session-token --duration-seconds 129600 || true
aws ec2 describe-elastic-gpus || true
aws ec2 describe-hosts || true
aws ec2 describe-instances || true
aws ec2 describe-network-acls || true
aws ec2 describe-reserved-instances || true
aws ec2 describe-security-groups || true
aws ec2 describe-snapshots || true
aws ec2 describe-volumes || true
aws ec2 describe-vpcs || true
aws resourcegroupstaggingapi get-resources || true

exit
