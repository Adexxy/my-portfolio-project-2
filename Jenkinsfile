pipeline {
    agent {
        docker {
            image 'node:latest'
            args '-p 3000:3000'
        }
    }

    // environment {
    //     // Define environment variables here
    //     NEXUS_CREDENTIAL_ID = 'f87a2a46-8d1f-4c60-86ee-302c3e93619d'
    //     ARTIFACT_PATH = 'commerce-app.tar.gz'  // Path to save the artifact
    //     NEXUS_URL = "http://localhost:8081/repository/all-types"  // Adjust the repository URL as needed
    //     ARTIFACT_VERSION = "0.1.1"
    //     NEXUS_USERNAME = "username"
    //     NEXUS_PWD = "nexus-pwd"
    // }
    
    environment {
    //     // Define environment variables here
    //     NEXUS_VERSION = "nexus3"
    //     NEXUS_PROTOCOL = "http"
    //     NEXUS_URL = 'localhost:8081'
    //     NEXUS_REPOSITORY = "all-types"
    //     NEXUS_CREDENTIAL_ID = 'f87a2a46-8d1f-4c60-86ee-302c3e93619d'
        ARTIFACT_PATH = 'commerce-app-0.1.1.tar.gz'  // Path to save the artifact
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
                sh 'tar -czvf commerce-app-0.1.1.tar.gz build'
            }
            post {
                success {
                    archiveArtifacts artifacts: "${ARTIFACT_PATH}", onlyIfSuccessful: true
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
        
        stage('Publish Artifact') {
            // stages {
            //     stage('Upload artifacts') {
            //         steps {
            //             script {
            //                 def nexusCredentials = credentials("${NEXUS_CREDENTIAL_ID}")

            //                 sh """
            //                     curl -v -u ${NEXUS_USERNAME}:${NEXUS_PWD} --upload-file ${ARTIFACT_PATH} ${NEXUS_URL}/${ARTIFACT_VERSION}/${ARTIFACT_PATH}
            //                 """
            //             }
            //         }
            //     }
            // }
        
            

            // steps {
            //     // This stage is optional
            //     echo 'Publishing artifact to Nexus...'
            //     script {
            //         def groupId = "node-app"
            //         def artifactId = "commerce-app"
            //         def version = "0.1.0"
                    
            //         // Specify the path to the artifact directory or file
            //         def artifactPath = ARTIFACT_PATH
                    
            //         nexusArtifactUploader(
            //             nexusVersion: NEXUS_VERSION,
            //             protocol: NEXUS_PROTOCOL,
            //             nexusUrl: "${NEXUS_URL}repository/${NEXUS_REPOSITORY}/node-app/${version}/${artifactId}-${version}",
            //             groupId: groupId,
            //             version: version,
            //             repository: NEXUS_REPOSITORY,
            //             credentialsId: NEXUS_CREDENTIAL_ID,
            //             artifacts: [
            //                 [artifactId: artifactId,
            //                 classifier: '',
            //                 file: artifactPath]
            //             ]
            //         )
            //     }
            // }

            steps {
                // This stage is optional
                echo 'Publishing artifact to Nexus...'
                script {
                    nexusArtifactUploader(
                        nexusVersion: 'nexus3',
                        protocol: 'http',
                        nexusUrl: 'http://localhost:8081/repository/',
                        groupId: 'test',
                        version: '0.1.1',
                        repository: 'all-types',
                        credentialsId: 'f87a2a46-8d1f-4c60-86ee-302c3e93619d',
                        artifacts: [
                            [artifactId: 'commerce-app',
                            classifier: '',
                            file: 'commerce-app-' + '0.1.1' + '.tar.gz',
                            type: '.tar.gz']
                        ]
                    )
                }
            }
        }
    }
}
