pipeline {
    agent any

    parameters {
        string(name: 'INSTANCE_PUBLIC_IP', defaultValue: '13.126.222.122', description: 'INSTANCE_PUBLIC_IP ')
        string(name: 'EFS_DNS_NAME', defaultValue: 'fs-06260c452c8798bd6.efs.ap-south-1.amazonaws.com', description: ' EFS_DNS_NAME ')
    }

    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }

    stages {
        stage('Deploy in EC2') {
            steps {
                script {
                    git branch: 'dev-5', url: 'https://github.com/juleshkumar/new-test.git'
                    sh "ansible-playbook -i inventory.ini deploy.yml --extra-vars 'ec2_ip=${params.INSTANCE_PUBLIC_IP} efs_dns_name=${params.EFS_DNS_NAME}'"
                }
            }
        }
    }
}
