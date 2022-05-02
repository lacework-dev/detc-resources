---
title: ec2instance
---

The `ec2instance` extension can be used to deploy an AWS compute instance.

## Example Usage

```yaml
---
example:
  steps:
    - name: vpc
      extension: VPC.AWS
      tags: infrastructure
      args:
        name: "new-vpc"
    - name: instance
      extension: EC2Instance
      tags: infra
      needs:
        - vpc
      args:
        vpc_id: !lookup /vpc/outputs/vpc_id
        subnet: !lookup /vpc/outputs/subnet_id1
        instance_name: "new-instance"
```


## Arguments

### `instance_name`
| | |
| --- | --- |
| Required | `true` |
| Type | `string` |
Determine what to call this new compute instance.

### `vpc_id`
| | |
| --- | --- |
| Required | `true` |
| Type | `string` |
Set the AWS VPC ID to use.

### `subnet`
| | |
| --- | --- |
| Required | `true` |
| Type | `string` |
Set the AWS subnet ID to use.

### `ports`
| | |
| --- | --- |
| Required | `false` |
| Type | `string` |
Set the ports to expose on the public IP (comma separated).

## Outputs

| Name      | Type | Description
| ----------- | ----- | ----------- |
| ip | string | the public ip of the new instance |
| pem  | string | The SSH private key for connecting to the new instance |
| public_key | string | The SSH public_key in the authorized_keys file|
| sg_id | string | The AWS security-group that is assigned to the node |
| instance_id | string | the ID of the new AWS instance |
| keypair | string | the name of the keypair assigned to the instance | 
| private_ip | string | the private IP address of the new instance |
