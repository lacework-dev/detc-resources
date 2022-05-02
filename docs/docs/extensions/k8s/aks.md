---
title: AKS
---

The AKS extension can be used to deploy a simple AKS cluster.

## Example Usage

```yaml
---
azure-k8s:
  steps:
    - name: k8s
      extension: AKS
      args:
        deployment_name: sharedaks
        azure_app_id: !secret azure.app_id
        azure_password: !secret azure.password
        azure_subscription_id: !secret azure.subscription_id
        azure_tenant_id: !secret azure.tenant_id
        azure_location: !secret azure.region
```

## Arguments

### `azure_app_id`
| | |
| --- | --- |
| Required | `true` |
| Type | `string` |
The application registration ID to use when creating the new cluster

### `azure_password`
| | |
| --- | --- |
| Required | `true` |
| Type | `string` |
The application registration password to use when creating the new cluster

### `azure_subscription_id`
| | |
| --- | --- |
| Required | `true` |
| Type | `string` |
The Azure subscription ID to create the new resource in

### `azure_tenant_id`
| | |
| --- | --- |
| Required | `true` |
| Type | `string` |
The Azure tenant ID to create the new resource in

### `azure_location`
| | |
| --- | --- |
| Required | `true` |
| Type | `string` |
Define which Azure region to build the resources in.

### `deployment_name`
| | |
| --- | --- |
| Required | `true` |
| Type | `string` |
What should the new deployment be called (the cluster is named using this argument).

### `instance_size`
| | |
| --- | --- |
| Required | `false` |
| Type | `string` |
The Azure compute machine size to use.

## Outputs

| Name      | Type | Description
| ----------- | ----- | ----------- |
| cluster_id | string | id of the cluster created |
| cluster_name | string | friendly name of the cluster created |
| cluster_endpoint | string | URL for the K8s API |
| kubectl_config | string | kubectl configuration file |
| resource_group_name | string | the Azure resource group the cluster was created in |
