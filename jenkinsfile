pipeline {
    agent any
    // tools {
    //     terraform "terraform-1" # no lo agregue todavia
    // }

    stages {
        stage('Git Checkout') {
            steps { 
                git branch: 'main', url: 'https://github.com/PabloEscales/iac-petclinic.git'
            }
        }

        stage('Terraform Version') {
            steps {
               sh label: '', script: 'terraform -version'
            }
        }

        // stage('Terraform Apply') {
        //     steps {
        //        sh label: '', script: 'terraform apply -auto-approve'
        //     }
        // }
    }
}
