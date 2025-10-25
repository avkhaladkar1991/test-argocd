pipeline {
    agent any

    environment {
        PATH = "/usr/local/bin:/opt/homebrew/bin:$PATH"  // Ensure Jenkins sees docker
        DOCKER_REGISTRY = 'avkhaladkar1991'
        IMAGE_NAME = "${DOCKER_REGISTRY}/my-app"
        DOCKER_CRED = credentials('dockerhub-creds')       // Docker Hub credentials
        KUBE_CONFIG = credentials('kubeconfig-cred-id')    // Kubeconfig secret file
    }

    stages {
        stage('Checkout') {
            steps {
                // Public repo; no Git credentials needed
                git branch: 'main', url: 'https://github.com/avkhaladkar1991/test-argocd.git'
            }
        }

        stage('Check Docker') {
            steps {
                sh 'which docker'
                sh 'docker version'
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', 
                                                 usernameVariable: 'DOCKER_USER', 
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:latest -f docker/Dockerfile ."
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
                withKubeConfig([credentialsId: 'kubeconfig-cred-id']) {
                    sh """
                        kubectl get nodes
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
