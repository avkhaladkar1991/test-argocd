pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = '<YOUR_DOCKER_REGISTRY>'
        IMAGE_NAME = "${DOCKER_REGISTRY}/my-app"
        KUBE_CONFIG = credentials('kubeconfig-cred-id')
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/<YOUR_USERNAME>/my-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:latest", "-f docker/Dockerfile .")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub-credentials-id') {
                        docker.image("${IMAGE_NAME}:latest").push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes with Helm') {
            steps {
                withKubeConfig([credentialsId: 'kubeconfig-cred-id']) {
                    sh """
                        helm upgrade --install my-app helm/my-app \
                        --set image.repository=${IMAGE_NAME} \
                        --set image.tag=latest
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
