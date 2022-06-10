pipelineJob('ticketing-app') {
  definition {
    cpsScm {
      scm {
        git('https://github.com/lacework-demo/ticketing-app.git', 'main', {node -> node / 'extensions' << '' })
      }
    }
  }
}

multibranchPipelineJob('ticketing-app-frontend') {
    factory {
        workflowBranchProjectFactory {
            scriptPath('frontend/Jenkinsfile')
        }
    }
    branchSources {
      github {
        id('23232323')
        scanCredentialsId("github-pat")
        checkoutCredentialsId("github-pat")
        repoOwner("lacework-demo")
        repository("ticketing-app")
        buildOriginBranch(false)
        buildOriginBranchWithPR(false)
        buildOriginPRMerge(true)
      }
    }
    orphanedItemStrategy {
        discardOldItems {
            numToKeep(10)
        }
    }
}
