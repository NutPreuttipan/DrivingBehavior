pipeline {
    agent any
      stages {

      stage('One') {
          steps {
              echo 'hi, this tis steps one from jenkins file'
          }
      }

      stage('Checkout') {
        steps {
          checkout scm
        }
      }

      stage('Running Tests') {
          steps {
            parallel (
              "Unit Tests": {
                sh 'echo "Unit Tests"'
                sh 'fastlane test'
              }
            )
          }
      }
}
