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
        
        stage('Quality-gate') {
            steps {
                echo 'SonarQube Quality gate Passed successful'
            }
        }
        
        stage('Deploy') {
            steps {
                echo 'Pass!'
            }
        }

        stage('Test') {
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
      
    post {
        always {
            echo "This will always run"
        }
        success {
            echo "This will run only if successful"
        }
        failure {
            echo "This will run only if failed"
        }
        unstable {
            echo "This will run only if the run wae marked as unstable"
        }
        changed {
            echo "This will run only if the state of the pipeline changed"
        }
    }

}