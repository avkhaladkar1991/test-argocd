pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'avkhaladkar1991'
        IMAGE_NAME = "${DOCKER_REGISTRY}/my-app"
        DOCKER_CRED = credentials('dockerhub-creds')   // Docker Hub creds
        GIT_CRED = credentials('github-creds')           // Git creds
        KUBE_CONFIG = credentials('kubeconfig-cred-id') // Kubeconfig file
    }

    stages {
        stage('Checkout') {
            steps {
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
