//This pipeline usage is to delete logs after successful run of Job in Master-Agent Architecture
pipeline {
    agent {
        label 'AGENT-1'
    }
    stages {
        stage('Build') {
            steps {
                sh 'echo This is Build'
            }
        }
        stage('Test') {
            steps {
                sh 'echo This is Test'
            }
        }
        stage('Deploy') {
            steps {
                sh 'echo This is Deploy'
                error 'This will get failed'
            }
        }
    }
    post {
        always {
            echo "This section run always"
            deleteDir()
        }
        success {
            echo "This section run when the pipeline success"
            deleteDir()
        }
        failure {
            echo "This section run when the pipeline failure"
            deleteDir()
        }
    }
}