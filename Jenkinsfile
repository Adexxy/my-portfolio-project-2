def artifactId = 'commerce-app'
def artifactFilename = "${artifactId}.tar.gz"

pipeline {
    agent {
        docker {
            image 'node:latest'
            args '-p 3000:3000'
        }
    }
    
    environment {
        // Define environment variables here
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = '172.19.0.4:8081'
        NEXUS_REPOSITORY = "all-types"
        NEXUS_CREDENTIAL_ID = 'f87a2a46-8d1f-4c60-86ee-302c3e93619d'
        ARTIFACT_PATH = "${artifactFilename}"  // Path to save the artifact
        DOCKER_USER = "dmancloud"
        DOCKER_PASS = 'dockerhub'
        IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
    }

    stages {
        stage('Build') {
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }
        
        stage('Test') {
            steps {
                sh 'npm test'
            }
        }
        
        stage('Package') {
            when {
                branch 'dev'
            }
            steps {
                sh "tar -czvf ${artifactFilename} build"
            }
            post {
                success {
                    archiveArtifacts artifacts: "${ARTIFACT_PATH}", onlyIfSuccessful: true
                }
            }
        }
        
        stage('Preview & Manual Approval') {
            when {
                branch 'dev'
            }
            steps {
                sh 'npm start &'
                sh "echo 'Now...Visit http://localhost:3000 to see your Node.js/React application in action.'"
                input "Preview the application and approve to proceed"
            }
        }
        
        stage('Publish Artifact') {
            when {
                branch 'dev'
            }
            steps {
                echo 'Publishing artifact to Nexus...'
                script {
                    def groupId = "development"
                    def version = "0.1.0"
                    
                    nexusArtifactUploader(
                        nexusVersion: NEXUS_VERSION,
                        protocol: NEXUS_PROTOCOL,
                        nexusUrl: NEXUS_URL,
                        groupId: groupId,
                        version: version,
                        repository: NEXUS_REPOSITORY,
                        credentialsId: NEXUS_CREDENTIAL_ID,
                        artifacts: [
                            [artifactId: artifactId,
                            classifier: '',
                            file: artifactFilename,
                            type: 'tar.gz']
                        ]
                    )
                }
            }
        }
        stage {
            // Build and upload container image
            steps {
                script {
                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image = docker.build "${IMAGE_NAME}"
                    }

                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')
                    }
                }
            }
        }
    }
}
