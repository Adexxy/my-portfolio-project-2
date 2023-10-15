pipeline {
    agent any

    tools {
        nodejs 'Node20'
    }
    
    environment {
        NEXUS_VERSION = 'nexus3'
        NEXUS_PROTOCOL = 'http'
        NEXUS_URL = '172.19.0.4:8081'
        NEXUS_REPOSITORY = 'all-types'
        NEXUS_CREDENTIAL_ID = 'f87a2a46-8d1f-4c60-86ee-302c3e93619d'
        ARTIFACTID = 'commerce-app'
        APP_VERSION = '0.1.0'
        DOCKER_USER = 'adexxy'
        DOCKER_CREDENTIAL_ID = 'a9402d12-9abe-40d0-811a-494fd59283c7'
        ARTIFACT_FILE_NAME = "${ARTIFACTID}.tar.gz"
        IMAGE_NAME = "${DOCKER_USER}/${ARTIFACTID}"
        IMAGE_TAG = "${APP_VERSION}-${BUILD_NUMBER}"
        MANIFEST_FILE = 'argo/commerce-app.yaml'  // Path to your Kubernetes manifest file
        GIT_CREDENTIAL_ID = '0d9032a7-24ac-41f1-8353-0279820df4ed'
        GIT_REPO = 'github.com/Adexxy/my-portfolio-project-2.git'
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
            steps {
                sh "tar -czvf ${ARTIFACT_FILE_NAME} ."
            }
            post {
                success {
                    archiveArtifacts artifacts: "${ARTIFACT_FILE_NAME}", onlyIfSuccessful: true
                }
            }
        }
        
        stage('Preview & Manual Approval') {
            // when {
            //     branch 'dev'
            // }
            steps {
                // sh 'cd build && python -m http.server &'
                sh 'npm start &'
                sh "echo 'Now...Visit http://localhost:3000 to see your Node.js/React application in action.'"
                input "Preview the application and approve to proceed"
            }
        }

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

        stage("Trivy Scan") {
            steps {
                script {
		            sh ('docker run -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image ${IMAGE_NAME}:${IMAGE_TAG} --no-progress --scanners vuln  --exit-code 0 --severity HIGH,CRITICAL --format table')
                }
            }
        }

        stage('Update Kubernetes Manifest and Commit to Branch') {
            steps {
                withCredentials([usernamePassword(credentialsId: GIT_CREDENTIAL_ID, passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                    script {
                        sh "cp ${MANIFEST_FILE}.bak ${MANIFEST_FILE}"
                        sh "sed -i 's|{{IMAGE_TAG}}|${IMAGE_TAG}|' ${MANIFEST_FILE}"

                        // Use withCredentials to securely pass GIT_USERNAME and GIT_PASSWORD to the git push command
                        withCredentials([usernamePassword(credentialsId: GIT_CREDENTIAL_ID, passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                            sh "git add ${MANIFEST_FILE}"
                            sh "git commit -m 'Update manifest with latest image tag version-${IMAGE_TAG}'"

                            sh "git push https://${GIT_USERNAME}:${GIT_PASSWORD}@${GIT_REPO} HEAD:${GIT_BRANCH}"  // Push changes to the current branch
                        }
                    }
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
                        version: IMAGE_TAG,
                        repository: NEXUS_REPOSITORY,
                        credentialsId: NEXUS_CREDENTIAL_ID,
                        artifacts: [
                            [artifactId: ARTIFACTID,
                            classifier:'',
                            file: "${ARTIFACTID}" + '.tar.gz',
                            type: 'tar.gz']
                        ]
                    )
                }
            }
        }

        stage ('Cleanup Artifacts') {
            steps {
                script {
                    sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }
}

