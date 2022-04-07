pipelineJob('ecomm') {
  definition {
    cpsScm {
      scm {
        git('https://github.com/lacework-demo/unhackable-ecommerce-app.git', 'main', {node -> node / 'extensions' << '' })
      }
    }
  }
}

