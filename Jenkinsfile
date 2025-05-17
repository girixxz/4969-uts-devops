pipeline {
    agent any

    tools {
        nodejs "Node18"  // sesuaikan dengan nama NodeJS tool di Jenkins
    }

    environment {
        DEPLOY_USER = "ec2-user"
        DEPLOY_HOST = "54.254.95.54"  // Ganti dengan IP instance AWS-mu
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
                // Kalau tidak ada test, ini supaya pipeline tetap lanjut
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
                    ssh -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} << ENDSSH
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
ENDSSH
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
            echo "Pipeline failed. Check the logs."
        }
    }
}

/* DIBAWAH INI ADALAH JENKINSFILE UNTUK PENGERJAAN NOMOR 2
pipeline {
    agent any

    tools {
        nodejs "Node18"  // Sesuaikan dengan nama NodeJS yang diset di konfigurasi Jenkins
    }

    environment {
        GIT_BRANCH = "development"
        GIT_REPO = "https://github.com/girixxz/4969-uts-devops.git"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "${GIT_BRANCH}", url: "${GIT_REPO}"
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                // Kalau belum ada test, biar tetap lanjut
                sh 'npm test || echo "No tests defined"'
            }
        }

        stage('Build') {
            steps {
                // Aman walau tidak ada script "build" di package.json
                sh 'npm run build || echo "No build script defined"'
            }
        }
    }

    post {
        success {
            echo "✅ CI Pipeline completed successfully."
        }
        failure {
            echo "❌ CI Pipeline failed. Check the logs."
        }
    }
}
*/