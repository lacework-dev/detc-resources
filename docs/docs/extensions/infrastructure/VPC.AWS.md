---
title: VPC.AWS
---

The EKS extension can be used to deploy a simple EKS cluster. As a result of this deployment, a new EKS cluster in a new
VPC and subnets will be created.

## Example Usage

```yaml
---
example:
  steps:
    - name: new-vpc
      extension: VPC.AWS
      tags: infrastructure
      args:
        name: "new-vpc"
```

## Arguments

### `name`
| | |
| --- | --- |
| Required | `true` |
| Type | `string` |
Determine what to call this new VPC.

## Outputs

| Name      | Type | Description
| ----------- | ----- | ----------- |
| vpc_id | string | id of the new vpc |
| subnet_id1 | string | id of the first subnet, in region's availability zone a  |
| subnet_id2 | string | id of the second subnet, in region's availability zone b  |

