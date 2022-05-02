---
title: azurecompute
---

The `azurecompute` extension can be used to deploy an Azure compute instance.

## Example Usage

```yaml
---
example:
  steps:
    - name: instance
      extension: AzureCompute
      tags: infra
      args:
        region: !secret azure.region
        instance_name: "my-instance"
```

## Arguments

### `instance_name`
| | |
| --- | --- |
| Required | `true` |
| Type | `string` |
Determine what to call this new compute instance.

### `region`
| | |
| --- | --- |
| Required | `true` |
| Type | `string` |
Set the Azure location to use.

## Outputs

| Name      | Type | Description
| ----------- | ----- | ----------- |
| ip | string | the public ip of the new instance |
| ssh_key | string | The SSH private key for connecting to the new instance |
