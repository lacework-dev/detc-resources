---
title: eCommerce
---

For an overview of the eCommerce application, please view the central documentation [here](https://docs.google.com/document/d/1jBppUJLL-hD4q96LktEl5i0NyAck-Nla4bz2hF484ts/edit#heading=h.1xmv54f7g99). This documentation only contains the relevant information for deploying it via the `detc` tool.

**Supported Clouds**: `Azure, AWS`

## Detailed, step by step documentation

All `detc` plans can be reviewed via the `--preview` flag. For all the commands listed below, replace `--apply` with `--preview` to get more details.

:::tip
You may want to increase verbosity via `--verbose` or even `--trace` to get all details you may want from the preview command.
:::

## Plan Launch Commands

### Azure

> Note: Requires the AKS plan to be deployed

```
detc create \
--plan https://raw.githubusercontent.com/lacework-dev/detc-resources/main/plans/k8s/aks.yaml \
--plan https://raw.githubusercontent.com/lacework-demo/unhackable-ecommerce-app/main/deploy/ecommerce-aks.yaml \
--apply
```

### AWS

> Note: Requires the EKS plan to be deployed

```
detc create \
--plan https://raw.githubusercontent.com/lacework-demo/unhackable-ecommerce-app/main/deploy/ecommerce-eks.yaml \
--plan https://raw.githubusercontent.com/lacework-dev/detc-resources/main/plans/k8s/eks.yaml \
--apply
```

## Outputs

Review the step outputs via `detc deployments`. The URL for the application can be found in the `ecommerce` step, named `frontend_app_url`.
