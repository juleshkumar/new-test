pipeline {
    agent any
    
    stages {
        stage('Deploy to EC2') {
            steps {
                git branch: 'dev-3', url: 'https://github.com/juleshkumar/new-test.git'
                
                script {
                    sh 'ansible-playbook -i inventory.ini deploy.yml'
                }
            }
        }
    }
}
