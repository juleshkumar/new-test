pipeline {
    agent any

    parameters {
        string(name: 'EC2_IP', defaultValue: '35.154.30.158', description: 'EC2 IP Address')
        string(name: 'region', defaultValue: 'ap-south-1', description: 'Region')
        string(name: 'output', defaultValue: 'text', description: 'Output format')
        string(name: 'efs_id', defaultValue: 'fs-01d723ddeee3bd322.efs.ap-south-1.amazonaws.com', description: 'Namespace')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }

    stages {
        stage('Deploy in EC2') {
            steps {
                script {
                    def inventoryContent = "[ec2]\n${params.EC2_IP} ansible_user=ubuntu ansible_ssh_private_key_file=/var/lib/jenkins/keypairs/jenkins-test-server2-keypair.pem"
                    sh "echo '${inventoryContent}' > inventory.ini"

                    git branch: 'dev-3', url: 'https://github.com/juleshkumar/new-test.git'
                    
                    sh "ansible-playbook -i inventory.ini deploy.yml --extra-vars 'efs_dns_name=${params.efs_id} aws_access_key_id=${env.AWS_ACCESS_KEY_ID} aws_secret_access_key=${env.AWS_SECRET_ACCESS_KEY} aws_region=${params.region} aws_output_format=${params.output} '"
                }
            }
        }
    }
}
