pipeline {
    agent any

    parameters {
        string(name: 'EC2_IP', defaultValue: '65.0.71.239', description: 'EC2 IP Address')
    }

    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }

    stages {
        stage('Deploy in EC2') {
            steps {
                script {
                    def inventoryContent = "[ec2]\n${params.EC2_IP} ansible_user=ubuntu ansible_ssh_private_key_file=/var/lib/jenkins/keypairs/jenkins-test-server2-keypair.pem"
                    sh "echo '${inventoryContent}' > inventory.ini"

                    git branch: 'dev-4', url: 'https://github.com/juleshkumar/new-test.git'
                    sh "ansible-playbook -i inventory.ini deploy.yml"
                }
            }
        }
    }
}
