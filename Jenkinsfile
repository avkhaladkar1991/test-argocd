pipeline {
    agent any

    environment {
        // Set full path to docker binary
        DOCKER_BIN = "/usr/local/bin/docker"
        DOCKER_IMAGE = "avkhaladkar1991/my-app:latest"
        DOCKER_REGISTRY = "docker.io"
        DOCKER_USER = credentials('docker-username')  // Jenkins credentials ID for username
        DOCKER_PASS = credentials('docker-password')  // Jenkins credentials ID for password
    }

    stages {
        stage('Checkout SCM') {
            steps {
                git url: 'https://github.com/avkhaladkar1991/test-argocd.git', branch: 'main', credentialsId: 'github-creds'
            }
        }

        stage('Check Docker') {
            steps {
                sh "${DOCKER_BIN} --version"
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh "${DOCKER_BIN} login -u $USER -p $PASS ${DOCKER_REGISTRY}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build image using Dockerfile in 'app/' folder
                sh "${DOCKER_BIN} build -t ${DOCKER_IMAGE} -f app/Dockerfile ./app"
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "${DOCKER_BIN} push ${DOCKER_IMAGE}"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "Deploy to Kubernetes skipped for now"
                // You can add kubectl apply commands here
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Deployment failed!"
        }
    }
}
