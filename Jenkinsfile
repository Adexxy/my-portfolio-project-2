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
        IMAGE_TAG = "${APP_VERSION}-test"   //"${APP_VERSION}-${BUILD_NUMBER}"
        MANIFEST_FILE = 'argo/commerce-app.yaml'  // Path to your Kubernetes manifest file
        GIT_CREDENTIAL_ID = '0d9032a7-24ac-41f1-8353-0279820df4ed'
    }

    stages {
        // stage('Build') {
        //     steps {
        //         sh 'npm install'
        //         sh 'npm run build'
        //     }
        // }
        
        // stage('Test') {
        //     steps {
        //         sh 'npm test'
        //     }
        // }
        
        // stage('Package') {
        //     steps {
        //         sh "tar -czvf ${ARTIFACT_FILE_NAME} ."
        //     }
        //     post {
        //         success {
        //             archiveArtifacts artifacts: "${ARTIFACT_FILE_NAME}", onlyIfSuccessful: true
        //         }
        //     }
        // }
        
        // stage('Preview & Manual Approval') {
        //     // when {
        //     //     branch 'dev'
        //     // }
        //     steps {
        //         // sh 'cd build && python -m http.server &'
        //         sh 'npm start &'
        //         sh "echo 'Now...Visit http://localhost:3000 to see your Node.js/React application in action.'"
        //         input "Preview the application and approve to proceed"
        //     }
        // }

        // stage('Build and Push Docker Image') {
        //     steps {
        //         script {
        //             // Log in to Docker registry using Jenkins credentials
        //             withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIAL_ID, passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
        //                 sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"
        //             }

        //             // Build and push the Docker image
        //             sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
        //             sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
        //         }
        //     }
        // }

        // stage("Trivy Scan") {
        //     steps {
        //         script {
		//             sh ('docker run -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image ${IMAGE_NAME}:${IMAGE_TAG} --no-progress --scanners vuln  --exit-code 0 --severity HIGH,CRITICAL --format table')
        //         }
        //     }
        // }

        stage('Update Kubernetes Manifest') {
            steps {
                withCredentials([usernamePassword(credentialsId: GIT_CREDENTIAL_ID, passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                    script {
                        sh "cp ${MANIFEST_FILE}.bak ${MANIFEST_FILE}"
                        sh "sed -i 's|{{IMAGE_TAG}}|${IMAGE_TAG}|' ${MANIFEST_FILE}"

                        // Check if the branch 'new-branch' exists
                        def branchExists = sh(script: 'git branch --list new-branch', returnStatus: true) == 0

                        if (!branchExists) {
                            sh "git checkout -b new-branch"
                        }

                        sh "git add ${MANIFEST_FILE}"
                        sh "git commit -m 'Update manifest with latest image tag'"

                        sh "git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/Adexxy/my-portfolio-project-2.git ${branchExists ? 'new-branch' : 'dev2'}"
                    }
                }
            }
        
            

            // steps {
            //     withCredentials([usernamePassword(credentialsId: GIT_CREDENTIAL_ID, passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
            //         script {
            //             // ... other steps

            //             // Assuming REPO_URL is the Git repository URL
            //             def repoUrlWithCredentials = "https://${GIT_USERNAME}:${GIT_PASSWORD}@https://github.com/Adexxy/my-portfolio-project-2/tree/dev"
                        
            //             // Perform git operations
            //             sh "git add ."  // Add all changes
            //             sh "git commit -m 'Jenkins automated commit'"  // Commit changes
            //             sh "git push ${repoUrlWithCredentials} HEAD:${GIT_BRANCH}"  // Push changes to the current branch
            //         }
            //     }
            // }  

            // steps {
            //     script {
            //         // Copy the .bak file as the new manifest
            //         sh "cp ${MANIFEST_FILE}.bak ${MANIFEST_FILE}"

            //         // Replace the placeholder in the manifest with the updated Docker image tag
            //         sh "sed -i 's|{{IMAGE_TAG}}|${IMAGE_TAG}|' ${MANIFEST_FILE}"

            //         // Commit the changes to the Git repository
            //         sh "git add ${MANIFEST_FILE}"
            //         sh "git commit -m 'Update manifest with latest image tag'"

            //         // Push the changes to the Git repository
            //         sh "git push ${GIT_BRANCH}"
            //     }
            // }
        }

        // stage('Publish Artifact to Nexus') {
        //     steps {
        //         echo 'Publishing artifact to Nexus...'
        //         script {
        //             def groupId = "development"
        //             nexusArtifactUploader(
        //                 nexusVersion: NEXUS_VERSION,
        //                 protocol: NEXUS_PROTOCOL,
        //                 nexusUrl: NEXUS_URL,
        //                 groupId: groupId,
        //                 version: IMAGE_TAG,
        //                 repository: NEXUS_REPOSITORY,
        //                 credentialsId: NEXUS_CREDENTIAL_ID,
        //                 artifacts: [
        //                     [artifactId: ARTIFACTID,
        //                     classifier:'',
        //                     file: "${ARTIFACTID}" + '.tar.gz',
        //                     type: 'tar.gz']
        //                 ]
        //             )
        //         }
        //     }
        // }

        // stage ('Cleanup Artifacts') {
        //     steps {
        //         script {
        //             sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
        //         }
        //     }
        // }
    }
}

