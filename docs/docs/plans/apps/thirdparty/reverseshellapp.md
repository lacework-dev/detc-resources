---
title: Reverse Shell Simulation App
---

For an overview of the Reverse Shell Simulation example application, view the documentation [here](https://github.com/lacework-community/reverse-shell-simulation-app). This documentation only contains the relevant information for deploying it via the `detc` tool.

> NOTE: This plan deploys an instance and the application to it; however no instrumentation is deployed. If additional instrumentation is desired, the public IP and SSH key of the instance can be retrieved from the outputs and documented below.

**Supported Clouds**: `AWS`

## Detailed, step by step documentation

All `detc` plans can be reviewed via the `--preview` flag. For all the commands listed below, replace `--apply` with `--preview` to get more details.

:::tip
You may want to increase verbosity via `--verbose` or even `--trace` to get all details you may want from the preview command.
:::

## Plan Launch Commands

```
detc create \
--plan https://raw.githubusercontent.com/lacework-dev/detc-resources/main/plans/reverse-shell-simulation.yml \
--apply
```


## Outputs

Review the step outputs via `detc deployments`. The URL for the application can be found in the `reverseshell-nodeapp` step, named `app_url`.
