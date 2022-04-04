pipelineJob('exampleapp') {
  definition {
    cpsScm {
      scm {
        git {
          remote {
            url('https://github.com/ipcrm/example-app.git')
          }
        }
      }
    }
  }
}

