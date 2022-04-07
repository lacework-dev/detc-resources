pipelineJob('ticketing-app') {
  definition {
    cpsScm {
      scm {
        git('https://github.com/lacework-demo/ticketing-app.git', 'main', {node -> node / 'extensions' << '' })
      }
    }
  }
}

