---
title: Extensions
---

The extension resources found in the DETC catalog are 'Wrapper Extensions'. For details about all extension types, see
the `detc` tool documentation [here](https://lacework-dev.github.io/detc/extensions)

### Wrapper Extensions

A wrapper extension 'wraps' a core extension. They are defined in YAML and reside in the [detc-resources](https://github.com/lacework-dev/detc-resources) repository. The purpose of wrapper extension is to package some code into a re-usable unit called in a step. For example, the EKS extension is actually a wrapper extension that uses the Terraform extension to deploy EKS. Common use cases can be created as wrapper extensions and simplify their re-use. 
