---
title: Bank of Anthos
---

For an overview of the Bank of Anthos example application, view the documentation [here](https://github.com/GoogleCloudPlatform/bank-of-anthos). This documentation only contains the relevant information for deploying it via the `detc` tool.

**Supported Clouds**: `Google`

## Detailed, step by step documentation

All `detc` plans can be reviewed via the `--preview` flag. For all the commands listed below, replace `--apply` with `--preview` to get more details.

:::tip
You may want to increase verbosity via `--verbose` or even `--trace` to get all details you may want from the preview command.
:::

## Plan Launch Commands

### GCP

> Note: Requires the GKE plan to be deployed

```
detc create \
--plan https://raw.githubusercontent.com/lacework-dev/detc-resources/main/plans/k8s/gke.yaml \
--plan https://raw.githubusercontent.com/lacework-dev/detc-resources/main/plans/bankofanthos/gke.yml \
--apply
```


## Outputs

Review the step outputs via `detc deployments`. The URL for the application can be found in the `deploy-boa` step, named `app_url`.
