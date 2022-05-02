---
title: GKE
---

This plan deploys GKE.  In addition, the plan also adds Lacework instrumentation to the cluster.

**Supported Clouds**: `GCP`

## Required Secrets

`lacework.accss_token`: Access token to use on the deployed workloads  

## Detailed, step by step documentation

All `detc` plans can be reviewed via the `--preview` flag. For all the commands listed below, replace `--apply` with `--preview` to get more details.

:::tip
You may want to increase verbosity via `--verbose` or even `--trace` to get all details you may want from the preview command.
:::

## Plan Launch Commands

```
detc create \
--plan https://raw.githubusercontent.com/lacework-dev/detc-resources/main/plans/k8s/gke.yaml \
--apply
```


## Outputs

Review the step outputs via `detc deployments`. EKS step outputs include the required `kubectl` configuration to connect (deployment name is `gcp-k8s`).
