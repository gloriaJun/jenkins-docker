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
        script {
          try {
            echo 'error'
            sh 'exit 1'
          } catch (error) {
            echo 'skip error'
            currentBuild.result='UNSTABLE'
          }
        }
      }
    }
    stage('Stage 3') {
      steps {
        echo 'run stage 3 job'
      }
    }
  }
  post {
    success {
      echo 'jobcsuccess'
    }
    unstable {
      echo 'unstable'
    }
    failure {
      echo 'job failed'
    }
  }
}