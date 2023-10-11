def artifactId = 'commerce-app'
def artifactFilename = "${artifactId}.tar.gz"
def dockerImageName = "${artifactId}:${BUILD_NUMBER}"


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


        DOCKERHUB_CREDENTIALS = credentials('a9402d12-9abe-40d0-811a-494fd59283c7')
        DOCKER_IMAGE = "${dockerImageName}"

        // DOCKER_USER = "dmancloud"
        // DOCKER_PASS = 'dockerhub'
        // IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        // IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"

        // DOCKER_HUB_REGISTRY = 'docker.io'
        // DOCKER_HUB_USERNAME = credentials('docker-hub-credentials-id').username
        // DOCKER_HUB_PASSWORD = credentials('docker-hub-credentials-id').password
 
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
                branch 'dev2'
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
            steps {
                sh 'npm start &'
                sh "echo 'Now...Visit http://localhost:3000 to see your Node.js/React application in action.'"
                input "Preview the application and approve to proceed"
            }
        }
        
        stage('Build Docker Image') {
            when {
                branch 'dev2'
            }
            steps {
                sh "/usr/bin/docker build -t ${dockerImageName} ."
                                   
            }
        }

        stage('Publish Artifact') {
            when {
                branch 'dev2'
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
    }
}
