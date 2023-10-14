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
        DOCKER_CREDENTIAL_ID = 'a9402d12-9abe-40d0-811a-494fd59283c7'
        ARTIFACT_FILE_NAME = "${ARTIFACTID}.tar.gz"
        IMAGE_NAME = "${DOCKER_USER}/${ARTIFACTID}"
        IMAGE_TAG = "${APP_VERSION}-${BUILD_NUMBER}"
        MANIFEST_FILE = 'path/to/deployment.yaml'  // Path to your Kubernetes manifest file
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
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIAL_ID, passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
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
                            [artifactId: ARTIFACTID,
                            classifier: '',
                            file: ARTIFACT_FILE_NAME,
                            type: 'tar.gz']
                        ]
                    )
                }
            }
        }

        // stage("Trivy Scan") {
        //     steps {
        //         script {
		//    sh ('docker run -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image dmancloud/complete-prodcution-e2e-pipeline:1.0.0-22 --no-progress --scanners vuln  --exit-code 0 --severity HIGH,CRITICAL --format table')
        //         }
        //     }

        // }

        // stage ('Cleanup Artifacts') {
        //     steps {
        //         script {
        //             sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
        //             sh "docker rmi ${IMAGE_NAME}:latest"
        //         }
        //     }
        // }


        // stage("Trigger CD Pipeline") {
        //     steps {
        //         script {
        //             sh "curl -v -k --user admin:${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' 'https://jenkins.dev.dman.cloud/job/gitops-complete-pipeline/buildWithParameters?token=gitops-token'"
        //         }
        //     }

        // }

    }
}


pipeline {
    agent any

    environment {
        DOCKER_IMAGE_TAG = 'your-docker-registry/your-app:latest'  // Set the desired Docker image tag
        MANIFEST_FILE = 'path/to/deployment.yaml'  // Path to your Kubernetes manifest file
    }

    stages {
        stage('Update Kubernetes Manifest') {
            steps {
                script {
                    // Replace the placeholder in the manifest with the desired Docker image tag
                    sh "sed -i 's|{{IMAGE_TAG}}|${DOCKER_IMAGE_TAG}|' ${MANIFEST_FILE}"
                }
            }
        }
        
        // Other stages...
    }
}
