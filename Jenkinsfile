pipeline {
    agent any

    parameters {
        string(name: 'INSTANCE_PUBLIC_IP', defaultValue: '13.126.222.122', description: 'INSTANCE_PUBLIC_IP ')
    }

    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }

    stages {
        stage('Deploy in EC2') {
            steps {
                script {
                    git branch: 'dev-4', url: 'https://github.com/juleshkumar/new-test.git'
                    sh "ansible-playbook -i inventory.ini deploy.yml --extra-vars 'EC2_IP=${params.INSTANCE_PUBLIC_IP}'"
                }
            }
        }
    }
}
