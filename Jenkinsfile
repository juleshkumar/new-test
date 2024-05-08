pipeline {
    agent any

    parameters {
        string(name: 'EC2_IP', defaultValue: '13.201.58.76', description: 'EC2 IP Address')
        string(name: 'EFS_DNS_NAME', defaultValue: 'fs-0bfedde77438dfa58.efs.ap-south-1.amazonaws.com', description: ' EFS_DNS_NAME ')
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
                    sh "ansible-playbook -i inventory.ini deploy.yml --extra-vars 'efs_dns_name=${params.EFS_DNS_NAME}'"
                }
            }
        }
    }
}
