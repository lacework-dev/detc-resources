---
title: EKS
---

The EKS extension can be used to deploy a simple EKS cluster. As a result of this deployment, a new EKS cluster in a new
VPC and subnets will be created.


## Example Usage

```yaml
---
aws-k8s:
  steps:
    - name: k8s
      extension: EKS
      args:
        region: !secret aws.region
        deployment_name: sharedeks
```

## Arguments

### `region`
| | |
| --- | --- |
| Required | `true` |
| Type | `string` |
Define which AWS region to build the resources in.

### `deployment_name`
| | |
| --- | --- |
| Required | `true` |
| Type | `string` |
What should the new deployment be called (the cluster is named using this argument).

## Outputs

| Name      | Type | Description
| ----------- | ----- | ----------- |
| cluster_id | string | id of the cluster created |
| cluster_arn | string | ARN of the created cluster |
| cluster_endpoint | string | URL for the K8s API |
| cluster_security_group_id | string | name of the security group the control traffic in the clsuter |
| kubectl_config | string | kubectl configuration file |
| config_map_aws_auth | string | configuration map for IAM roles (see [docs](https://registry.terraform.io/providers/hashicorp/aws/2.33.0/docs/guides/eks-getting-started)) |
| cluster_name | string | friendly name of the cluster created |
| vpc_id | string | vpc ID created for the cluster | 
| public_subnet_id | string | subnet id of the public subnet created |
| private_subnet_id | string | subnet id of the private subnet created |
| region | string | region that the cluster was created in |
| cluster_worker_security_group_id | string | security group that the worker nodes reside |
