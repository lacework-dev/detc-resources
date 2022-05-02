---
title: GKE
---

The GKE extension can be used to deploy a simple GKE cluster.


## Example Usage

```yaml
---
gcp-k8s:
  steps:
    - name: k8s
      extension: GKE
      tags: infrastructure
      args:
        region: !secret gcp.region
        project: !secret gcp.project_id
        cluster_name: sharedgke
```

## Arguments

### `region`
| | |
| --- | --- |
| Required | `true` |
| Type | `string` |
Define which GCP region to build the resources in.

### `project`
| | |
| --- | --- |
| Required | `true` |
| Type | `string` |
Define which GCP project to build the resources in.

### `cluster_name`
| | |
| --- | --- |
| Required | `true` |
| Type | `string` |
What should the new GKE clsuter be called.

## Outputs

| Name      | Type | Description
| ----------- | ----- | ----------- |
| cluster_endpoint | string | URL for the K8s API |
| kubectl_config | string | kubectl configuration file |
| cluster_ca_certificate | string | CA cert details used by the cluster |
| cluster_name | string | friendly name of the cluster created |
| network | string | the network created for this new cluster |
| subnet | string | the subnet created for this new cluster |
