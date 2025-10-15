pipeline {
    agent {
        label "javaapp"  
    }
    stages {
        stage ('git checkout') {
            steps {
                git url: 'https://github.com/pragati029/spring-petclinic.git',
                branch: 'main'
            }
            
        }
        stage ('build and scan') {
            steps {
                withCredentials ([string(credentialsId: 'sonar_id', variable: 'newtoken')]) {
                    withSonarQubeEnv('sonar') {
                        sh """
                        mvn package sonar:sonar \
                        -Dsonar.projectKey=pragati029_spring-petclinic \
                        -Dsonar.organization=pragati029 \
                        -Dsonar.host.url=https://sonarcloud.io \
                        -Dsonar.login=$newtoken
                        """
                    }
                }
            }
        }
        stage('Upload to JFrog') {
            steps {
                rtUpload(
                    serverId: 'jfrog_java',
                    spec: '''{
                        "files": [
                            {
                                "pattern": "target/*.jar",
                                "target": "jfrogjavaspc-libs-release-local"
                            }
                        ]
                    }'''
                )

                rtPublishBuildInfo(
                    serverId: 'jfrog_java'
                )
            }
        }
        stage ('Docker Build') {
            steps {
                sh 'docker build -t myimg:1.0 .'
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: 'target/*.jar'
            junit 'target/surefire-reports/*.xml'
        }
        success {
            echo ' This pipeline executed successfully!'
        }
        failure {
            echo ' Build failed! Please check the logs.'
        }
    }
}
    
