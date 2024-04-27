pipeline {
    agent any
    
    stages {
        stage('Deploy to EC2') {
            steps {
                // Checkout the Git repository
                git branch: 'dev-3', url: 'https://github.com/juleshkumar/new-test.git'
                
                // Run Ansible playbook
                script {
                    sh '''ansible-playbook -i inventory.ini deploy.yml \
                        --private-key=/var/lib/jenkins/keypairs/jenkins-test-server2-keypair.pem \
                        -e "ansible_ssh_extra_args='-o HostKeyAlgorithms=ssh-rsa'"'''
                }
            }
        }
    }
}
