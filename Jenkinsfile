pipeline {
    agent any

    parameters {
        string(name: 'EC2_IP', defaultValue: '65.0.71.239', description: 'INSTANCE_PUBLIC_IP')
    }

    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }

    stages {
        stage('Deploy in EC2') {
            steps {
                script {
                    git branch: 'dev-4', url: 'https://github.com/juleshkumar/new-test.git'
                    sh "ansible-playbook -e \"ec2_ip=${params.EC2_IP}\" deploy.yml"
                }
            }
        }
    }
}
