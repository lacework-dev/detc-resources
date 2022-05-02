---
title: Jenkins
---

This Jenkins plan deploys a server and an agent, both directly on EC2 instances. This Jenkins instance does have a default seed job created (seed job repository can be found [here](https://github.com/lacework-dev/detc-resources/tree/main/apps/jenkins/job-seeds)). However, the seed job can be discarded, and the instance can be used just like any other Jenkins instance.

> NOTE: The default job seed is how DETC managed environments are bootstrapped, view the documentation in the job seed folder for more details.

**Supported Clouds**: `AWS`

## Required Secrets

`lacework.accss_token`: Access token to use on the deployed workloads  
`lacework.account_name`: Account name to store in Jenkins secret  
`jenkins.admin_id`: User name for the admin user  
`jenkins.admin_pass`: Password for the Jenkins admin user  
`dockerhub.user`: Dockerhub username for Jenkins secret  
`dockerhub.token`: Dockerhub access token for Jenkins secret  


> NOTE: For Jenkins deployment, your local `detc` configuration must contain Azure, GCP, and AWS credentials or the deployment is not successful. These cloud credentials are made available in the Jenkins instance



## Detailed, step by step documentation

All `detc` plans can be reviewed via the `--preview` flag. For all the commands listed below, replace `--apply` with `--preview` to get more details.

:::tip
You may want to increase verbosity via `--verbose` or even `--trace` to get all details you may want from the preview command.
:::

## Plan Launch Commands

```
detc create \
--plan https://raw.githubusercontent.com/lacework-dev/detc-resources/main/plans/jenkins/jenkins.yaml \
--apply
```


## Outputs

Review the step outputs via `detc deployments`. The URL for the Jenkins instance can be found in the `jenkins-server` step, named `jenkins_url`.
