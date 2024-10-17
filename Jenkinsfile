pipeline {
    agent { label 'jenkins-agent' }

    environment {
        // Set your GitHub repository URL
        REPO_URL = 'https://github.com/belalelnady/automated-pipeline'
        
        // Define the Docker image name based on the repository name
        IMAGE_NAME = 'dockerized-web-app'
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone the repository
                git url: "${REPO_URL}", branch: 'main'
                
            }
        }
        // stage('Install') {
        //         steps {
        //             //  Install dependencies once
        //             sh 'npm  --prefix web-app ci'   
        //         }
        //     }
    
        // stage('Test') {
        //             steps {
        //                 // Test the web app before building it with jest
        //                sh 'npm --prefix web-app test'
        //             }
        //         }


        stage('Build Docker Image') {
            steps {
                script {
                    // Run Docker build for the Dockerfile in the repository
                    sh 'docker build -t ${IMAGE_NAME} .'
                }
            }
        }

        stage('Push Docker Image') {
      
            steps {
                script {
                    // Log in to Docker Hub (assuming credentials are stored in Jenkins)
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                  
                        sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"
                        // Tag the Docker image and push to Docker Hub
                        sh 'docker tag ${IMAGE_NAME} ${DOCKER_USER}/${IMAGE_NAME}:latest'
                        sh 'docker push ${DOCKER_USER}/${IMAGE_NAME}:latest'
                    }
                }
            }
        }

           stage('Run Ansible Playbook') {
           
            steps {
                script {
                    // Run the Ansible command
                     sh'ANSIBLE_CONFIG=./ansible.cfg ansible-playbook ansible-playbook.yml'
                     // Replace with your playbook and inventory files
                   
                }
            }
        }
    }
    

    post {
        success { //runs on success of pipeline
            emailext (
                to: 'engahmedharse@gmail.com',
                subject: "Build Success: ${currentBuild.fullDisplayName}",
                body: "<p>Good news! The build was successful.</p>",
                mimeType: 'text/html'
            )
        }
        failure { //runs on failure of pipeline
            emailext (
                to: 'engahmedharse@gmail.com',
                subject: "Build Failed: ${currentBuild.fullDisplayName}",
                body: "<p>Oops! The build has failed.</p>",
                mimeType: 'text/html'
            )
        }
        always {
            // Cleanup Docker images
            sh 'docker rmi ${IMAGE_NAME} || true'
            sh 'echo  cleaned'
        }
 }

}
