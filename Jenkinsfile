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
        NEXUS_URL = 'localhost:8081'
        NEXUS_REPOSITORY = "npm-snapshots"
        NEXUS_CREDENTIAL_ID = 'f87a2a46-8d1f-4c60-86ee-302c3e93619d'
        ARTIFACT_PATH = 'commerce-app.tar.gz'  // Path to save the artifact
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
                sh 'tar -czvf commerce-app.tar.gz build'
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
                // sh 'cd build && python -m http.server &'
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
                // This stage is optional
                echo 'Publishing artifact...'
            }
        }

        stage('Store Artifact in Nexus') {
            steps {
                script {
                    def groupId = "node-app"
                    def artifactId = "commerce-app"
                    def version = "1.0.0"
                    
                    // Specify the path to the artifact directory or file
                    def artifactPath = NODE_APP_DIR
                    
                    nexusArtifactUploader(
                        nexusVersion: NEXUS_VERSION,
                        protocol: NEXUS_PROTOCOL,
                        nexusUrl: "${NEXUS_URL}repository/${NEXUS_REPOSITORY}/node-app/${version}/${artifactId}-${version}",
                        groupId: groupId,
                        version: version,
                        repository: NEXUS_REPOSITORY,
                        credentialsId: NEXUS_CREDENTIAL_ID,
                        artifacts: [
                            [artifactId: artifactId, classifier: '', file: artifactPath]
                        ]
                    )
                }
            }
        }

        // stage('Store Artifact in Nexus') {
        //     steps {
        //         script {
        //             // Modify the groupId to include the desired path
        //             def groupId = "node-app/1.0.0"

        //             // Modify the artifactId to match the desired filename or identifier
        //             def artifactId = "commerce-app"

        //             // Specify the path to the artifact file
        //             def artifactPath = "commerce-app.tar.gz"

        //             def nexusUploadUrl = "${NEXUS_URL}repository/${NEXUS_REPOSITORY}/" + "${groupId.replace('/', '/')}/${artifactId}/1.0.0/${artifactId}-1.0.0"

        //             nexusArtifactUploader(
        //                 nexusVersion: NEXUS_VERSION,
        //                 protocol: NEXUS_PROTOCOL,
        //                 nexusUrl: nexusUploadUrl,
        //                 groupId: groupId,
        //                 version: "1.0.0", // Modify the version as needed
        //                 repository: NEXUS_REPOSITORY,
        //                 credentialsId: NEXUS_CREDENTIAL_ID,
        //                 artifacts: [
        //                     [artifactId: artifactId, classifier: '', file: artifactPath]
        //                 ]
        //             )
        //         }
        //     }
        // }

        // stage('Push to Nexus repository') {
        //     steps {
        //         nexusArtifactUploader(
        //             nexusVersion: 'nexus3',
        //             protocol: 'http',
        //             nexusUrl: 'localhost:8081',
        //             repository: 'npm-snapshots',
        //             credentialsId: 'f87a2a46-8d1f-4c60-86ee-302c3e93619d',
        //             groupId: 'node-app',
        //             version: '1.0.0',
        //             artifacts: [
        //                 [artifactId: 'commerce-app',
        //                 type: 'tar.gz',
        //                 classifier: '',
        //                 file: 'commerce-app.tar.gz']
        //             ]
        //         )
        //     }
        // }

    }
}
