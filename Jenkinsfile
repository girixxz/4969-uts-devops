pipeline {
    agent any

    tools {
        nodejs "Node18"  // nama yang kamu kasih waktu konfigurasi
    }


    environment {
        DEPLOY_USER = "ec2-user"
        DEPLOY_HOST = "54.254.95.54"  // Ganti dengan IP instance AWS dari output terraform
        SSH_CREDENTIALS_ID = "girixxz_ssh"  // ID credential SSH di Jenkins
        APP_DIR = "/home/ec2-user/4969-uts-devops"
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
                sh 'node -v'
                sh 'npm install'
                sh 'npm run build'
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
                    if [ ! -d "${APP_DIR}" ]; then
                    cd /home/ec2-user
                    git clone https://github.com/girixxz/4969-uts-devops.git
                    fi

                    cd ${APP_DIR}
                    git pull origin development
                    npm install

                    if ! command -v pm2 &> /dev/null; then
                    sudo npm install -g pm2
                    fi

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
    }
}
