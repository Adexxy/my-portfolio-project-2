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
            steps {
                // This stage is optional
                echo 'Publishing artifact to Nexus...'
                script {
                    def groupId = "development"
                    def artifactId = "commerce-app"
                    def version = "0.1.0"
                    
                    // Specify the path to the artifact directory or file
                    def artifactPath = ARTIFACT_PATH
                    
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
                            file: artifactId + version + '.tar.gz',
                            type: 'tar.gz']
                        ]
                    )
                }
            }

            // steps {
            //     // This stage is optional
            //     echo 'Publishing artifact to Nexus...'
            //     script {
            //         nexusArtifactUploader(
            //             nexusVersion: 'nexus3',
            //             protocol: 'http',
            //             nexusUrl: '172.19.0.4:8081',
            //             groupId: 'test',
            //             version: '0.1.0',
            //             repository: 'all-types',
            //             credentialsId: 'f87a2a46-8d1f-4c60-86ee-302c3e93619d',
            //             artifacts: [
            //                 [artifactId: 'commerce-app',
            //                 classifier: '',
            //                 file: 'commerce-app' + '' + '.tar.gz',
            //                 type: 'tar.gz']
            //             ]
            //         )
            //     }
            // }
        }
    }
}
