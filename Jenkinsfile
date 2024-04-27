pipeline {
    agent any
    
    stages {
        stage('Deploy to EC2') {
            steps {
                // Checkout the Git repository
                git branch: 'dev-3', url: 'https://github.com/juleshkumar/new-test.git'
                
                // Run Ansible playbook
                script {
                    sh 'ansible -i inventory.ini ec2 -m ping'
                }
            }
        }
    }
}
