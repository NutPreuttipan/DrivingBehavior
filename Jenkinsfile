pipeline {
    agent any
      stages {
        stage('One') {
            steps {
                echo 'hi, this tis steps one from jenkins file'
            }
        }
        stage('Two') {
            steps {
                input('Do you want to proceed?')
            }
        }

        stage('Three') {
            when {
                not {
                  branch "master"
                }
            }
            steps {
                echo "hello"
            }
        }

      }

}
