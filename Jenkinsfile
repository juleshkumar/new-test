pipeline {
    agent any

    parameters {
        string(name: 'EC2_IP', defaultValue: '13.233.165.203', description: 'EC2 IP Address')
        string(name: 'region', defaultValue: 'ap-south-1', description: 'Region')
        string(name: 'output', defaultValue: 'text', description: 'Output format')
        string(name: 'namespace', defaultValue: 'test', description: 'Namespace')
        string(name: 'efs_id', defaultValue: 'fs-01d723ddeee3bd322', description: 'EFS id')
        string(name: 'consul_version', defaultValue: '10.14.3', description: '')
        string(name: 'elasticsearch_version', defaultValue: '19.13.10', description: '')
        string(name: 'kafka_version', defaultValue: '18.0.3', description: '')
        string(name: 'nginx_ic_version', defaultValue: '9.2.22', description: '')
        string(name: 'logstash_version', defaultValue: '5.1.13', description: '')
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

                    git branch: 'dev-4', url: 'https://github.com/juleshkumar/new-test.git'
                    
                    sh "ansible-playbook -i inventory.ini deploy.yml --extra-vars 'efs_id=${params.efs_id} aws_access_key_id=${env.AWS_ACCESS_KEY_ID} aws_secret_access_key=${env.AWS_SECRET_ACCESS_KEY} aws_region=${params.region} aws_output_format=${params.output} namespace_name=${params.namespace} consul_version=${params.consul_version} elasticsearch_version=${params.elasticsearch_version} kafka_version=${params.kafka_version} nginx_ic_version=${params.nginx_ic_version} logstash_version=${params.logstash_version}'"
                }
            }
        }
    }
}
