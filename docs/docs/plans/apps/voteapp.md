---
title: VoteApp
---

For an overview of the VoteApp, please view the central documentation [here](https://docs.google.com/document/d/1jBppUJLL-hD4q96LktEl5i0NyAck-Nla4bz2hF484ts/edit#heading=h.8akh3vl1z4ni). This documentation only contains the relevant information for deploying it via the `detc` tool.

**Supported Clouds**: `Azure, Google, AWS`

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
--plan https://raw.githubusercontent.com/lacework-dev/detc-resources/main/plans/voteapp/voteapp-gke.yml \
--apply
```

### Azure

> Note: Requires the AKS plan to be deployed

```
detc create \
--plan https://raw.githubusercontent.com/lacework-dev/detc-resources/main/plans/k8s/aks.yaml \
--plan https://raw.githubusercontent.com/lacework-dev/detc-resources/main/plans/voteapp/voteapp-aks.yml \
--apply
```

### AWS

> Note: Requires the EKS plan to be deployed

```
detc create \
--plan https://raw.githubusercontent.com/lacework-dev/detc-resources/main/plans/voteapp/voteapp-eks.yml \
--plan https://raw.githubusercontent.com/lacework-dev/detc-resources/main/plans/k8s/eks.yaml \
--apply
```

## Outputs

Review the step outputs via `detc deployments`. The URL for both the `voteapp` and `resultapp` can be found in the `voteapp` steps outputs.
