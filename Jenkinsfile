pipeline {
    agent any
    tools {
        terraform 'terraform-1'
    }

    stages {
        stage('Git Checkout') {
            steps { 
                git branch: 'main', url: 'https://github.com/PabloEscales/iac-petclinic.git'
            }
        }

        stage('Terraform Version') {
            steps {
                script {
                    tool 'terraform-1'
                    sh 'terraform -version'
                }
            }
        }
    }
}
