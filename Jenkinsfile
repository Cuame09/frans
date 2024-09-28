pipeline {
    agent any
	environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout code from GitHub repository
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url:'https://github.com/setor2211/frans.git',   
                    ]]
                ])
            }
        }
        stage('Terraform Init') {
            steps {
                // Initialise Terraform
                sh 'terraform init'
            }
        }
        stage ("terraform Action") {
            steps {
                echo "Terraform action is --> ${action}"
                sh ('terraform ${action} -auto-approve') 
            }
        }
    }
}
