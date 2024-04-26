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
        string(name: 'instance_sg_name', defaultValue: 'ec2-sg', description: 'sg name')
        string(name: 'ami', defaultValue: 'ami-09298640a92b2d12c', description: 'ami here')
        string(name: 'instance_type', defaultValue: 't3a.medium', description: 'instance type')
        string(name: 'key_pair', defaultValue: 'jenkins-test-server2-keypair', description: 'key pair ')
        string(name: 'efs_name', defaultValue: 'test-efs', description: 'efs name ')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'ap-south-1'
    }

    stages {
        stage('VPC Creation') {
            steps {
                script {
                    dir('vpc_workspace') {
                    git branch: 'main', url: 'https://github.com/juleshkumar/new-test.git'
                    sh 'terraform init'
                    sh "terraform plan -out vpc_tfplan \
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
                    sh 'terraform show -no-color vpc_tfplan > vpc_tfplan.txt'
                        script {
                    if (params.action == 'apply') {
                        if (!params.autoApprove) {
                            def plan = readFile 'vpc_tfplan.txt'
                            input message: "Do you want to apply the plan?",
                            parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                        }

                        sh "terraform ${params.action} -input=false vpc_tfplan"
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

                    // Extract VPC and subnet IDs from Terraform output
                    def vpcIdOutput = sh(returnStdout: true, script: 'terraform output vpc_id').trim()
                    def vpcId = vpcIdOutput.replaceAll('"', '')

                    def subnetId1Output = sh(returnStdout: true, script: 'terraform output public_subnet_a_ids').trim()
                    def subnetId1 = subnetId1Output.replaceAll('"', '')

                    def subnetId2Output = sh(returnStdout: true, script: 'terraform output public_subnet_b_ids').trim()
                    def subnetId2 = subnetId2Output.replaceAll('"', '')

                    def subnetId3Output = sh(returnStdout: true, script: 'terraform output private_subnet_a_ids').trim()
                    def subnetId3 = subnetId3Output.replaceAll('"', '')

                    def subnetId4Output = sh(returnStdout: true, script: 'terraform output private_subnet_b_ids').trim()
                    def subnetId4 = subnetId4Output.replaceAll('"', '')

                    env.VPC_ID = vpcId
                    env.SUBNET_ID1 = subnetId1
                    env.SUBNET_ID2 = subnetId2
                    env.SUBNET_ID3 = subnetId3
                    env.SUBNET_ID4 = subnetId4
                }
                }
            }
        }

        stage('Instance') {
            steps {
                script {
                    dir('instance_workspace') {
                    git branch: 'dev-1', url: 'https://github.com/juleshkumar/new-test.git'
                    sh 'terraform init'
                    def tfPlanCmd = "terraform plan -out instance_tfplan " +
                                    "-var 'instance_sg_name=${params.instance_sg_name}' " +
                                    "-var 'ami=${params.ami}' " +
                                    "-var 'region=${env.AWS_DEFAULT_REGION}' " +
                                    "-var 'access_key=${env.AWS_ACCESS_KEY_ID}' " +
                                    "-var 'secret_key=${env.AWS_SECRET_ACCESS_KEY}' " +
                                    "-var 'instance_type=${params.instance_type}' " +
                                    "-var 'key_pair=${params.key_pair}' " +
                                    "-var 'vpc_id=${env.VPC_ID}' " +
                                    "-var 'subnet_id=${env.SUBNET_ID1}'"
                    sh tfPlanCmd
                    sh 'terraform show -no-color instance_tfplan > instance_tfplan.txt'

                    if (params.action == 'apply') {
                        if (!params.autoApprove) {
                            def plan = readFile 'instance_tfplan.txt'
                            input message: "Do you want to apply the plan?",
                                  parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                        }
                        sh "terraform ${params.action} -input=false instance_tfplan"
                    } else if (params.action == 'destroy') {
                        sh "terraform ${params.action} --auto-approve -var 'instance_sg_name=${params.instance_sg_name}' " +
                           "-var 'ami=${params.ami}' " +
                           "-var 'instance_type=${params.instance_type}' " +
                           "-var 'key_pair=${params.key_pair}' " +
                           "-var 'access_key=${env.AWS_ACCESS_KEY_ID}' " +
                           "-var 'secret_key=${env.AWS_SECRET_ACCESS_KEY}' " +
                           "-var 'region=${env.AWS_DEFAULT_REGION}' " +
                           "-var 'vpc_id=${env.VPC_ID}' " +
                           "-var 'subnet_id=${env.SUBNET_ID1}'"
                    } else {
                        error "Invalid action selected. Please choose either 'apply' or 'destroy'."
                    }
                }
                }
            }
        }

        stage('EFS') {
            steps {
                script {
                    dir('efs_workspace') {
                    git branch: 'dev-2', url: 'https://github.com/juleshkumar/new-test.git'
                    sh 'terraform init'
                    def tfPlanCmd = "terraform plan -out instance_tfplan " +
                                    "-var 'sub2_id=${env.SUBNET_ID4}' " +
                                    "-var 'efs_name=${params.efs_name}' " +
                                    "-var 'vpc_id=${env.VPC_ID}' " +
                                    "-var 'region=${env.AWS_DEFAULT_REGION}' " +
                                    "-var 'sub1_id=${env.SUBNET_ID3}'"
                    sh tfPlanCmd
                    sh 'terraform show -no-color efs_tfplan > efs_tfplan.txt'

                    if (params.action == 'apply') {
                        if (!params.autoApprove) {
                            def plan = readFile 'efs_tfplan.txt'
                            input message: "Do you want to apply the plan?",
                                  parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                        }
                        sh "terraform ${params.action} -input=false efs_tfplan"
                    } else if (params.action == 'destroy') {
                        sh "terraform ${params.action} --auto-approve -var 'sub2_id=${env.SUBNET_ID4}' " +
                                    "-var 'efs_name=${params.efs_name}' " +
                                    "-var 'vpc_id=${env.VPC_ID}' " +
                                    "-var 'region=${env.AWS_DEFAULT_REGION}' " +
                                    "-var 'sub1_id=${env.SUBNET_ID3}'"
                    } else {
                        error "Invalid action selected. Please choose either 'apply' or 'destroy'."
                    }
                }
                }
            }
        }
    }
}
