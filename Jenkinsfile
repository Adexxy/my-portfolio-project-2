pipeline {
    agent any  // Use any available agent, as we'll run Docker commands directly on the Jenkins server
    environment {
        DOCKER_IMAGE = 'node:latest'
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = '172.19.0.4:8081'
        NEXUS_REPOSITORY = "all-types"
        NEXUS_CREDENTIAL_ID = 'f87a2a46-8d1f-4c60-86ee-302c3e93619d'
        ARTIFACTID = 'commerce-app'
        APP_VERSION = "0.1.0"
        DOCKER_USER = "adexxy"
        DOCKER_PASS = 'a9402d12-9abe-40d0-811a-494fd59283c7'
        ARTIFACT_FILE_NAME = "${ARTIFACTID}.tar.gz"
        IMAGE_NAME = "${DOCKER_USER}/${ARTIFACTID}"
        IMAGE_TAG = "${APP_VERSION}-${BUILD_NUMBER}"
    }
    stages {
        stage('Test Docker') {
            steps {
                script {
                    // Run Docker commands directly on the Jenkins server
                    sh 'docker --version'
                    sh 'docker ps'
                    sh 'pwd'
                }
            }
        }
        stage('Build and Test Node.js') {
            agent {
                docker {
                    image DOCKER_IMAGE
                    args '-p 3000:3000'
                }
            }
            steps {
                // Stash the build folder
                stash(name: 'buildFolder', includes: 'build/**')

                // Run your Node.js build
                sh 'npm install'
                sh 'npm run build'
                // Test commands here
                sh 'npm test'
                sh 'pwd'
            }
        }
        
        stage('Package') {
            steps {
                // Unstash the build folder
                unstash 'buildFolder'
                sh 'pwd'
                sh "tar -czvf ${ARTIFACT_FILE_NAME} build"
            }
            post {
                success {
                    archiveArtifacts artifacts: "${ARTIFACT_FILE_NAME}", onlyIfSuccessful: true
                }
            }
        }
        
        // stage('Preview & Manual Approval') {
        //     steps {
        //         sh 'npm start &'
        //         sh "echo 'Now...Visit http://localhost:3000 to see your Node.js/React application in action.'"
        //         input "Preview the application and approve to proceed"
        //     }
        // }
        

        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Log in to Docker registry using Jenkins credentials
                    withCredentials([usernamePassword(credentialsId: 'a9402d12-9abe-40d0-811a-494fd59283c7', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"
                    }

                    // Build and push the Docker image
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Publish Artifact to Nexus') {
            steps {
                echo 'Publishing artifact to Nexus...'
                script {
                    def groupId = "development"
                    nexusArtifactUploader(
                        nexusVersion: NEXUS_VERSION,
                        protocol: NEXUS_PROTOCOL,
                        nexusUrl: NEXUS_URL,
                        groupId: groupId,
                        version: APP_VERSION,
                        repository: NEXUS_REPOSITORY,
                        credentialsId: NEXUS_CREDENTIAL_ID,
                        artifacts: [
                            [ARTIFACTID: ARTIFACTID,
                            classifier: '',
                            file: ARTIFACT_FILE_NAME,
                            type: 'tar.gz']
                        ]
                    )
                }
            }
        }
    }
}
