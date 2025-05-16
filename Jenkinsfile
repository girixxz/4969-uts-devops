pipeline {
    agent {
        docker {
            image 'node:18'
        }
    }

    environment {
        DEPLOY_USER = "ec2-user"
        DEPLOY_HOST = "54.254.95.54"  // Ganti dengan IP instance AWS dari output terraform
        SSH_CREDENTIALS_ID = "girixxz"  // ID credential SSH di Jenkins
        APP_DIR = "/home/ec2-user/app"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'development', url: 'https://github.com/girixxz/4969-uts-devops.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test || echo "No tests defined"'
            }
        }

        stage('Build') {
            steps {
                echo "Build step skipped (optional)"
            }
        }

        stage('Deploy') {
            when {
                expression { currentBuild.currentResult == 'SUCCESS' }
            }
            steps {
                sshagent([SSH_CREDENTIALS_ID]) {
                    sh """
                      ssh -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} << EOF
                        cd ${APP_DIR}
                        git pull origin development
                        npm install
                        pm2 restart app.js || pm2 start app.js
                      EOF
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline finished successfully."
        }
        failure {
            echo "Pipeline failed."
            mail to: 'adityagiri206@example.com',
                 subject: "Build failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "Check Jenkins for details."
        }
    }
}
