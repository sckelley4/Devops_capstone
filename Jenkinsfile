pipeline {
    agent any

    environment {
        // credential ID to retrieve Docker Hub credentials
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
    }

    stages {
        stage('Clone, Build and Test') {
            steps {
                script {
                    checkout scm
                    // Use the credentials in script
                    withCredentials([usernamePassword(credentialsId: DOCKER_HUB_CREDENTIALS, usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                        sh 'docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD'
                        sh 'docker build -t sckelley/service1:${BUILD_NUMBER} ./service1'
                        sh 'docker build -t sckelley/service2:${BUILD_NUMBER} ./service2'

                        // Run automated tests for the microservices
                        sh 'docker run sckelley/service1:${BUILD_NUMBER} npm test'
                        sh 'docker run sckelley/service2:${BUILD_NUMBER} pytest'
                    }
                }
            }
        }

        stage('Deploy to Docker Hub') {
            steps {
                script {
                    // Push the Docker images to Docker Hub
                    sh 'docker push sckelley/service1:${BUILD_NUMBER}'
                    sh 'docker push sckelley/service2:${BUILD_NUMBER}'
                }
            }
        }
        
        stage('Code Quality Analysis') {
            steps {
                script {
                    def scannerHome = tool name: 'SonarQubeScanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                    withSonarQubeEnv('SonarQubeScanner') {
                        sh "${scannerHome}/bin/sonar-scanner"
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
