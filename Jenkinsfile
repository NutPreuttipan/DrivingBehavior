pipeline {
    agent any
      stages {
        stage('Complie') {
            steps {
                echo 'Complie successful'
            }
        }

        stage('Unit-test') {
            steps {
                echo 'Unit-test Passed successful'
            }
        }

        stage('Test') {
            when {
                not {
                  branch "master"
                }
            }
            steps {
                echo "hello from master"
            }
        }

      }
}
