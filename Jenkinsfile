pipeline {
    agent {
        docker {
            image 'node:latest'
            args '-p 3000:3000 -v /var/run/docker.sock:/var/run/docker.sock'
        }

    }
    
    environment {
        // Define environment variables here
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
        stage ('Test Docker') {
            sh 'docker --version'
            sh 'which docker'
        }
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
                sh "tar -czvf ${ARTIFACT_FILE_NAME} build"
            }
            post {
                success {
                    archiveArtifacts artifacts: "${ARTIFACT_FILE_NAME}", onlyIfSuccessful: true
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
        
        stage('Build and Push Docker Image') {
            when {
                branch 'dev2'
            }
            steps {
                // script {
                //     def dockerImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                //     docker.withRegistry('https://index.docker.io/v1/', DOCKER_USER, DOCKER_PASS) {
                //         dockerImage.push()
                //     }
                // }

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

        stage('Publish Artifact to Nexus') {
            when {
                branch 'dev2'
            }
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















// pipeline {
//     agent {
//         docker {
//             image 'node:latest'
//             args '-p 3000:3000'
//         }
//     }
    
//     environment {
//         // Define environment variables here
//         NEXUS_VERSION = "nexus3"
//         NEXUS_PROTOCOL = "http"
//         NEXUS_URL = '172.19.0.4:8081'
//         NEXUS_REPOSITORY = "all-types"
//         NEXUS_CREDENTIAL_ID = 'f87a2a46-8d1f-4c60-86ee-302c3e93619d'
//         ARTIFACT_PATH = "${ARTIFACT_FILE_NAME}"  // Path to save the artifact

//         APP_VERSION = "0.1.0"
//         DOCKERHUB_CREDENTIALS = credentials('a9402d12-9abe-40d0-811a-494fd59283c7')
//         IMAGE_TAG = "${DOCKER_IMAGE_NAME}"
//         ARTIFACTID = 'commerce-app'
//         ARTIFACT_FILE_NAME = "${ARTIFACTID}.tar.gz"

//         DOCKER_USER = "adexxy"
//         DOCKER_PASS = 'dockerhub'
//         IMAGE_NAME = "${DOCKER_USER}" + "/" + "${ARTIFACTID}"
//         IMAGE_TAG = "${APP_VERSION}-${BUILD_NUMBER}"

//         // DOCKER_HUB_REGISTRY = 'docker.io'
//         // DOCKER_HUB_USERNAME = credentials('docker-hub-credentials-id').username
//         // DOCKER_HUB_PASSWORD = credentials('docker-hub-credentials-id').password
 
//     }

//     stages {
//         stage('Build') {
//             steps {
//                 sh 'npm install'
//                 sh 'npm run build'
//             }
//         }
        
//         stage('Test') {
//             steps {
//                 sh 'npm test'
//             }
//         }
        
//         stage('Package') {
//             when {
//                 branch 'dev2'
//             }
//             steps {
//                 sh "tar -czvf ${ARTIFACT_FILE_NAME} build"
//             }
//             post {
//                 success {
//                     archiveArtifacts artifacts: "${ARTIFACT_PATH}", onlyIfSuccessful: true
//                 }
//             }
//         }
        
//         stage('Preview & Manual Approval') {
//             steps {
//                 sh 'npm start &'
//                 sh "echo 'Now...Visit http://localhost:3000 to see your Node.js/React application in action.'"
//                 input "Preview the application and approve to proceed"
//             }
//         }
        
//         stage {
//             // Build and upload container image
//             steps {
//                 script {
//                     docker.withRegistry('',DOCKER_PASS) {
//                         docker_image = docker.build "${IMAGE_IMAGE}"
//                     }

//                     docker.withRegistry('',DOCKER_PASS) {
//                         docker_image.push("${IMAGE_TAG}")
//                         docker_image.push('latest')
//                     }
//                 }
//             }
//         }

//         stage('Publish Artifact') {
//             when {
//                 branch 'dev2'
//             }
//             steps {
//                 echo 'Publishing artifact to Nexus...'
//                 script {
//                     def groupId = "development"
//                     nexusArtifactUploader(
//                         nexusVersion: NEXUS_VERSION,
//                         protocol: NEXUS_PROTOCOL,
//                         nexusUrl: NEXUS_URL,
//                         groupId: groupId,
//                         version: APP_VERSION,
//                         repository: NEXUS_REPOSITORY,
//                         credentialsId: NEXUS_CREDENTIAL_ID,
//                         artifacts: [
//                             [ARTIFACTID: ARTIFACTID,
//                             classifier: '',
//                             file: ARTIFACT_FILE_NAME,
//                             type: 'tar.gz']
//                         ]
//                     )
//                 }
//             }
//         }
//     }
// }
