#!/bin/bash
aws iam get-user --user-name admin
aws iam get-user --user-name root
aws iam add-user-to-group --user-name admin --group-name admin
aws iam add-user-to-group --user-name root --group-name admin
aws ec2 describe-instances
aws sts get-caller-identity
aws iam get-user
