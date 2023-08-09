pipeline {
    agent any

    environment {
        // Use the credential ID to retrieve Docker Hub credentials
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
    }

    stages {
        stage('Build and Deploy') {
            steps {
                script {
                    // Use the credentials in your script
                    withCredentials([usernamePassword(credentialsId: DOCKER_HUB_CREDENTIALS, usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                        sh 'docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD'
                        sh 'docker build -t sckelley/service1:${BUILD_NUMBER} ./service1'
                        sh 'docker build -t sckelley/service2:${BUILD_NUMBER} ./service2'
                        sh 'docker push sckelley/service1:${BUILD_NUMBER}'
                        sh 'docker push sckelley/service2:${BUILD_NUMBER}'
             }
            }
            }
        }
        // ...
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
