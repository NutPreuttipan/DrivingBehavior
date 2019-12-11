pipeline {
    agent any

    environment {
        // Fastlane Environment Variables
        LC_ALL = "en_US.UTF-8"
        LANG = "en_US.UTF-8"
    }
      stages {
        stage('Checkout') {
          steps {
            checkout scm
          }
        }

        stage('Dependecies') {
          steps {
            sh '/usr/local/bin/pod install'
          }
        }

        stage('Running Tests') {
            steps {
              parallel (
                "SwiftDrivingBehavior": {
                  sh 'fastlane test'
                  sh 'fastlane beta'
                  sh 'fastlane firebase'
                }
              )
            }
        }
    }
}
