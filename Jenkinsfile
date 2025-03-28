pipeline {
    agent any {
        stages {
            stage('Build') {
                steps {
                    sh 'echo "This is Build"'
                }
            }
            stage('Test') {
                steps {
                    sh 'echo " This is test"'
                }
            }
            stage('Deploy') {
                steps {
                    sh 'echo " This is Deploy" '
                    //error 'This is error section'
                }
            }
        }
    }
    post {
        always {
            echo "This section occurs always"
        }
        success {
            echo "This section occurs when the logic got success"
        }
        failure {
            echo "This section occurs when the logic failure"
        }
    }
}