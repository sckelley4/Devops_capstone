pipeline {
    agent any

    environment {
        // Define environment variables used in the pipeline
        DOCKER_HUB_USERNAME = credentials('DOCKER_HUB_USERNAME')
        DOCKER_HUB_PASSWORD = credentials('DOCKER_HUB_PASSWORD')
    }

    stages {
        stage('Build Service 1') {
            steps {
                script {
                    // Clone the repository and build Docker image for Service 1
                    git 'https://github.com/your-repo.git'
                    sh 'docker build -t your-dockerhub-username/service1:${BUILD_NUMBER} ./service1'
                }
            }
        }

        stage('Build Service 2') {
            steps {
                script {
                    // Build Docker image for Service 2
                    sh 'docker build -t your-dockerhub-username/service2:${BUILD_NUMBER} ./service2'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // Push Docker images to Docker Hub
                    withCredentials([usernamePassword(credentialsId: 'DOCKER_HUB_CREDENTIALS_ID', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                        sh 'docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD'
                        sh 'docker push your-dockerhub-username/service1:${BUILD_NUMBER}'
                        sh 'docker push your-dockerhub-username/service2:${BUILD_NUMBER}'
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Deploy microservices to Kubernetes using kubectl
                    sh 'kubectl apply -f ./kubernetes/service1-deployment.yaml'
                    sh 'kubectl apply -f ./kubernetes/service2-deployment.yaml'
                }
            }
        }
    }
}
