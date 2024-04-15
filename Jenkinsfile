pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
        string(name: 'name', defaultValue: 'test', description: 'enter name of your vpc')
        string(name: 'project', defaultValue: 'dev-testing', description: 'enter your project name')
        string(name: 'environment', defaultValue: 'uat', description: 'mention env name')
        string(name: 'region', defaultValue: 'ap-south-1', description: 'mention resource creation region')
        string(name: 'cidr_block', defaultValue: '10.87.0.0/16', description: 'enter the cidr for vpc')
        string(name: 'availability_zone_one', defaultValue: 'ap-south-1a', description: 'enter the az1')
        string(name: 'availability_zone_two', defaultValue: 'ap-south-1b', description: 'enter the az2')
        string(name: 'public_subnet_a_cidr_blocks', defaultValue: '10.87.0.0/18', description: 'enter cidr for public subnet 1a')
        string(name: 'public_subnet_b_cidr_blocks', defaultValue: '10.87.64.0/18', description: 'enter cidr for public subnet 1b')
        string(name: 'private_subnet_a_cidr_blocks', defaultValue: '10.87.128.0/18', description: 'enter cidr for pvt subnet 1a')
        string(name: 'private_subnet_b_cidr_blocks', defaultValue: '10.87.192.0/18', description: 'enter cidr for pvt subnet 1b')
        string(name: 'instance_sg_name', defaultValue: 'test-ec2-sg', description: 'sg name')
        string(name: 'ami', defaultValue: 'ami-09298640a92b2d12c', description: 'ami here')
        string(name: 'instance_type', defaultValue: 't3a.medium', description: 'instance type')
        string(name: 'key_pair', defaultValue: 'jenkins-test-server2-keypair', description: 'key pair ')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'ap-south-1'
    }

    stages {
        stage('Vpc Checkout') {
            steps {
                dir('vpc_workspace') {
                git branch: 'main', url: 'https://github.com/juleshkumar/new-test.git'
            }
        }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    dir('vpc_workspace') {
                    sh 'terraform init'
                    sh "terraform plan -out tfplan \
                            -var 'name=${params.name}' \
                            -var 'project=${params.project}' \
                            -var 'environment=${params.environment}' \
                            -var 'region=${params.region}' \
                            -var 'cidr_block=${params.cidr_block}' \
                            -var 'availability_zone_one=${params.availability_zone_one}' \
                            -var 'availability_zone_two=${params.availability_zone_two}' \
                            -var 'public_subnet_a_cidr_blocks=${params.public_subnet_a_cidr_blocks}' \
                            -var 'public_subnet_b_cidr_blocks=${params.public_subnet_b_cidr_blocks}' \
                            -var 'private_subnet_a_cidr_blocks=${params.private_subnet_a_cidr_blocks}' \
                            -var 'private_subnet_b_cidr_blocks=${params.private_subnet_b_cidr_blocks}'"
                    sh 'terraform show -no-color tfplan > tfplan.txt'
                        script {
                    if (params.action == 'apply') {
                        if (!params.autoApprove) {
                            def plan = readFile 'tfplan.txt'
                            input message: "Do you want to apply the plan?",
                            parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                        }

                        sh "terraform ${params.action} -input=false tfplan"
                    } else if (params.action == 'destroy') {
                        sh "terraform ${params.action} --auto-approve \
                                -var 'name=${params.name}' \
                                -var 'project=${params.project}' \
                                -var 'environment=${params.environment}' \
                                -var 'region=${params.region}' \
                                -var 'cidr_block=${params.cidr_block}' \
                                -var 'availability_zone_one=${params.availability_zone_one}' \
                                -var 'availability_zone_two=${params.availability_zone_two}' \
                                -var 'public_subnet_a_cidr_blocks=${params.public_subnet_a_cidr_blocks}' \
                                -var 'public_subnet_b_cidr_blocks=${params.public_subnet_b_cidr_blocks}' \
                                -var 'private_subnet_a_cidr_blocks=${params.private_subnet_a_cidr_blocks}' \
                                -var 'private_subnet_b_cidr_blocks=${params.private_subnet_b_cidr_blocks}'"
                    } else {
                        error "Invalid action selected. Please choose either 'apply' or 'destroy'."
                    }

            }
                    
                    // Generate outputs.tf file
                    sh 'terraform output -json > outputs.tf'
                }
            }
            }
        }

       stage('Instance Checkout') {
            steps {
                dir('instance_workspace') {
                git branch: 'dev-1', url: 'https://github.com/juleshkumar/new-test.git'
            }
            }
        }

        stage('Terraform Apply Stage 2') {
            steps {
                script {
            dir('instance_workspace') {
                sh 'terraform init'
                def tfOutputs = readFile '../vpc_workspace/outputs.tf'
                def parsedOutputs = new groovy.json.JsonSlurper().parseText(tfOutputs)

                // Store output values in environment variables for use in subsequent stages
                def param1Value = parsedOutputs.public_subnet_a_ids.value
                def param2Value = parsedOutputs.vpc_id.value

                if (params.action == 'apply') {
                    sh "terraform ${params.action} --auto-approve \
                            -var 'instance_sg_name=${params.instance_sg_name}' \
                            -var 'ami=${params.ami}' \
                            -var 'vpc_id=${param2Value}' \
                            -var 'instance_type=${params.instance_type}' \
                            -var 'subnet_id=${param1Value}' \
                            -var 'key_pair=${params.key_pair}'"
                } else if (params.action == 'destroy') {
                    sh "terraform ${params.action} --auto-approve \
                            -var 'instance_sg_name=${params.instance_sg_name}' \
                            -var 'ami=${params.ami}' \
                            -var 'vpc_id=${param2Value}' \
                            -var 'instance_type=${params.instance_type}' \
                            -var 'subnet_id=${param1Value}' \
                            -var 'key_pair=${params.key_pair}'"
                    } else {
                        error "Invalid action selected. Please choose either 'apply' or 'destroy'."
                    }

            }
                }
            }
            }
        }
    }
