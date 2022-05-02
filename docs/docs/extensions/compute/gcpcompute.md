---
title: gcpcompute
---

The `gcpcompute` extension can be used to deploy an Azure compute instance.

## Example Usage

```yaml
---
example:
  steps:
    - name: instance
      extension: GCPCompute
      args:
        region: !secret gcp.region
        project: !secret gcp.project_id
        instance_name: "example-instance"
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
Set the GCP region to use.

### `project`
| | |
| --- | --- |
| Required | `true` |
| Type | `string` |
Set the GCP project to use.

### `tags`
| | |
| --- | --- |
| Required | `false` |
| Type | `string` |
Set the GCP tags to assign (comma separated).

### `instance_size`
| | |
| --- | --- |
| Required | `false` |
| Type | `string` |
| Default | `e2-small` |
Set the GCP compute instance size to use.


## Outputs

| Name      | Type | Description
| ----------- | ----- | ----------- |
| ip | string | the public ip of the new instance |
| ssh_key | string | The SSH private key for connecting to the new instance |

