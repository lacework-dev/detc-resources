---
title: Activity Generation
---

Activity generation is used to create texture in a demo environment.  These plans are used to build dedicated 'activity' compute instances that execute activities against their corresponding cloud environment regularly.

**Supported Clouds**: `Azure, GCP`

## Detailed, step by step documentation

All `detc` plans can be reviewed via the `--preview` flag. For all the commands listed below, replace `--apply` with `--preview` to get more details.

:::tip
You may want to increase verbosity via `--verbose` or even `--trace` to get all details you may want from the preview command.
:::

## Plan Launch Commands

### GCP

```
detc create \
--plan https://raw.githubusercontent.com/lacework-dev/detc-resources/main/apps/activity/gcp.yml \
--apply
```

### Azure

```
detc create \
--plan https://raw.githubusercontent.com/lacework-dev/detc-resources/main/apps/activity/azure.yml \
--apply
```


## Outputs

Review the step outputs via `detc deployments`.
