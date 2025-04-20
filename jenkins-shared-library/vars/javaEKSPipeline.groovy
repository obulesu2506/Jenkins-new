def call(Map configMap){
    pipeline {
        agent {
            label 'AGENT-1'
        }
        options{
            timeout(time: 30, unit: 'Minutes')
            disableConcurrentBuilds()
        }
        parameters{
            booleanParam(name: 'deploy', defaultValue: false, description: 'Select to deploy or not')
        }
        environment {
            appVersion = '' //Glocal section and can e used across pipeline
            region = 'us-east-1'
            account_id = '396608804248'
            project = configMap.get("project")
            environment = 'dev'
            component = configMap.get("component")
        }
        stages {
            stage('Read Version') {
                steps {
                    script {
                        def pom = readMavenPom file: 'pom.xml'
                        appVersion = pom.version 
                        echo "App Version: ${appVersion}"
                    }
                }
            }
            stage('Intall Dependencies'){
                steps {
                    sh 'mvn clean package'
                }
            }
            stage('SonarQube Analysis'){
                environment {
                    SCANNER_HOME = tool 'sonar-6.0' //scanner config
                }
                steps {
                    //sonar server injection
                    withSonarQubeEnv('sonar-6.0'){
                        sh '$SCANNER_HOME/bin/sonar-scanner'
                        //generic scanner, it automatically understands the language and provide scan results
                    }
                }
            }
            stage('Quality Gates') {
                steps {
                    timeout(time: 5, unit: 'MINUTES') {
                        withForQualityGate abortPipeline: true
                    }
                }
            }
            stage('Docker Build') {
                steps {
                    withAWS(region: 'us-east-1', credentials: 'aws-creds-${environment}') {
                        sh """
                            aws ecr get-login-password --region ${region} | docker login  --username AWS --password-stdin ${account_id}.dkr.ecr.us-east-1.amazonaws.com

                            docker build -t ${account_id}.dkr.ecr.us-east-1.amazonaws.com/${project}/${environment}/${component}:${appVersion} .

                            docker images

                            docker push ${account_id}.dkr.ecr.us-east-1.amazonaws.com/${project}/${environment}/${component}:${appVersion}
                        """
                    }
                }
            }
            stage('Deploy'){
                when {
                    expression { params.deploy}
                }
                steps {
                    build job: "../${component}-cd", parameters: [
                        string(name: 'version', value: "$appVersion"),
                        string(name: 'ENVIRONMENT', value: "dev"),
                    ], wait: true
                } 
            }
        }
        post {
            aways {
                echo "This section runs always"
                deleteDir()
            }
            success {
                echo "This section runs when the pipeline success"
                deleteDir()
            }
            failure {
                echo "This section runs when the pipeline failure"
            }
        }
    }
}