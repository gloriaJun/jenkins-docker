#!/usr/bin/env groovy

void setBuildStatus(String context, String message, String state) {
  step([
    $class: "GitHubCommitStatusSetter",
    reposSource: [$class: "ManuallyEnteredRepositorySource", url: "${env.GIT_URL}"],
    contextSource: [$class: "ManuallyEnteredCommitContextSource", context: "ci/jenkins/${context}"],
    errorHandlers: [[$class: "ChangingBuildStatusErrorHandler", result: "UNSTABLE"]],
    statusBackrefSource: [$class: "ManuallyEnteredBackrefSource", backref: "${env.RUN_DISPLAY_URL}"],
    statusResultSource: [ $class: "ConditionalStatusResultSource", results: [[$class: "AnyBuildResult", message: message, state: state]] ]
  ]);
}

void notifySlack(String message, String color) {
  slackSend (channel: '#dev_github_noti', color: color, message: message + ": Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
}

pipeline {
  agent {
    dockerfile { filename 'Dockerfile' }
  }

  environment {
    // npm_config_cache = "npm-cache"
    HOME = "${env.WORKSPACE}"
    // NPM_CONFIG_PREFIX = "${env.HOME}/.npm"
    isMasterBuild = "${env.BRANCH_NAME ==~ /master$/}"
  }

  options {
      buildDiscarder(logRotator(artifactDaysToKeepStr: '1', artifactNumToKeepStr: '10', daysToKeepStr: '3',numToKeepStr: "10"))
      timestamps()
      timeout(time: 30, unit: 'MINUTES')
  }

  stages {
    stage('Checkout') {
      steps {
        sh 'which node'
        sh "npm --version"
        sh "node --version"
        sh 'which java'
        sh "java -version"
        sh "printenv"
        sh "${isMasterBuild}"
      }
      
    }
    stage('Stage 1') {
      when {
        expression { return isMasterBuild } 
      }
      steps {
        script {
          echo "run stage 1"
          if (isMasterBuild) {
            echo "master build"
          }
        }
      }
    }

    stage('Error Stage') {
      steps {
        catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
            echo 'error'
            sh 'exit 1'
        }
      }
    }

    stage('Stage 3') {
      environment {
        context="Stage3"
      }

      steps {
        setBuildStatus(context, "${context} Progressing...", "PENDING");
        echo 'run stage 3 job'
      }

      post {
        success {
          setBuildStatus("${context}", "${context} Success", "SUCCESS");
        }
        failure {
          setBuildStatus("${context}", "${context} Failed", "FAILURE");
        }
      }      
    }

    stage('Stage 4') {
      when {
        expression { return !isMasterBuild } 
      }
      steps {
        script {
          echo "run stage 4"
        }
      }
    }    
  }
  post {
    cleanup {
      cleanWs(
        deleteDirs: true,
        patterns: [
          [pattern: 'dist', type: 'INCLUDE'],
          [pattern: '.out', type: 'INCLUDE'],
        ]
      )
    }
    success {
      script {
        def previousResult = currentBuild.previousBuild?.result

        if (!previousResult || (previousResult && previousResult != currentBuild.result)) {
          notifySlack ('SUCCESS', '#00FF00')
        }
      }
    }
    unstable {
      notifySlack ('UNSTABLE', '#FFFF00')
    }
    failure {
      notifySlack ('FAILED', '#FF0000')
    }
  }
}