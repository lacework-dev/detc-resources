---
title: Ticketing
---

For an overview of the Ticketing app, please view the central documentation [here](https://docs.google.com/document/d/1jBppUJLL-hD4q96LktEl5i0NyAck-Nla4bz2hF484ts/edit#heading=h.uujexuxbgxvk). This documentation only contains the relevant information for deploying it via the `detc` tool.

**Supported Clouds**: `Google, AWS`

## Required secrets

`lacework.access_token`: An access token must be supplied, and this is used when instrumenting the compute instances involved in the ticketing application.

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
--plan https://raw.githubusercontent.com/lacework-demo/ticketing-app/main/deploy/ticketing-gcp.yaml \
--apply
```

### AWS

> Note: Requires the EKS plan to be deployed

```
detc create \
--plan https://raw.githubusercontent.com/lacework-demo/ticketing-app/main/deploy/ticketing-aws.yaml \
--plan https://raw.githubusercontent.com/lacework-dev/detc-resources/main/plans/k8s/eks.yaml \
--apply
```

## Outputs

Review the step outputs via `detc deployments`. The URL for the application can be found in the `frontend-k8s` step.
