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
  slackSend (channel: '#alert_th_bank', color: color, message: message + ": Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
}

pipeline {
  agent {
    dockerfile { filename 'Dockerfile' }
  }

  environment {
    // npm_config_cache = "npm-cache"
    HOME = "${env.WORKSPACE}"
    // NPM_CONFIG_PREFIX = "${env.HOME}/.npm"
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
      }
    }
  }
}