pipeline {
    agent any

    stages {
        stage('Git Checkout') {
            steps { 
                git branch: 'main', url: 'https://github.com/PabloEscales/iac-petclinic.git'
            }
        }

        stage('Git Version') {
            steps {
                sh 'git --version'
            }
        }
    }
}
