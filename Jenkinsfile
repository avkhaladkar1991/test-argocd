pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'avkhaladkar1991'
        IMAGE_NAME = "${DOCKER_REGISTRY}/my-app"
        DOCKER_CRED = credentials('dockerhub-creds')       // Docker Hub credentials
        KUBE_CONFIG = credentials('kubeconfig-cred-id')    // Kubeconfig secret file
    }

    stages {
        stage('Checkout') {
            steps {
                // Public repo; no Git credentials needed
                git 'https://github.com/avkhaladkar1991/test-argocd.git'
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
                    docker.withRegistry('', 'dockerhub-creds') {
                        docker.image("${IMAGE_NAME}:latest").push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // Use Jenkins stored kubeconfig to deploy via Helm
                withKubeConfig([credentialsId: 'kubeconfig-cred-id']) {
                    sh """
                        # Optional: check cluster nodes
                        kubectl get nodes

                        # Deploy using Helm
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
