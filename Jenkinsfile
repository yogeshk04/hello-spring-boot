@Library('shared-library') _
pipeline{

    agent any

    parameters{

        choice(name: 'action', choices: 'create\ndelete', description: 'Choose create/Destroy')
        // string(name: 'ImageName', description: "name of the docker build", defaultValue: 'hello-springboot')
        // string(name: 'ImageTag', description: "tag of the docker build", defaultValue: 'v1')
        // string(name: 'DockerHubUser', description: "name of the Application", defaultValue: 'yogeshk04')
        string(name: 'aws_account_id', description: " AWS Account ID", defaultValue: '383375023402')
        string(name: 'region', description: "Region of ECR", defaultValue: 'eu-central-1')
        string(name: 'ecr_repo_name', description: "name of the ECR", defaultValue: 'ars-marketplace')
        //string(name: 'cluster', description: "name of the EKS Cluster", defaultValue: 'demo-cluster1')
    }

    environment{

        AWS_ACCESS_KEY_ID = credentials('ACCESS_KEY')
        AWS_SECRET_KEY_ID = credentials('SECRET_KEY')
    }

    stages{
         
        stage('Git Checkout'){
                    when { expression {  params.action == 'create' } }
            steps{
                gitCheckout(
                branch: "master",
                url: "https://github.com/yogeshk04/hello-springboot.git"
            )
            }
        }
         stage('Unit Test maven'){
         
         when { expression {  params.action == 'create' } }

            steps{
               script{                   
                   mvnTest()
               }
            }
        }
         stage('Integration Test maven'){
         when { expression {  params.action == 'create' } }
            steps{
               script{
                   
                   mvnIntegrationTest()
               }
            }
        }
        /*
        stage('Static code analysis: Sonarqube'){
         when { expression {  params.action == 'create' } }
            steps{
               script{                   
                   def SonarQubecredentialsId = 'sonarqube-api'
                   staticCodeAnalysis(SonarQubecredentialsId)
               }
            }
        }
        stage('Quality Gate Status Check : Sonarqube'){
         when { expression {  params.action == 'create' } }
            steps{
               script{                   
                   def SonarQubecredentialsId = 'sonarqube-api'
                   qualityGateStatus(SonarQubecredentialsId)
               }
            }
        }
        */      
    stage('Maven Build : maven'){
         when { expression {  params.action == 'create' } }
            steps{
               script{  
                   
                   mvnBuild()
               }
            }
        }
    stage('Docker Image Build : ECR'){
         when { expression {  params.action == 'create' } }
            steps{
               script{                   
                   dockerBuild("${params.aws_account_id}","${params.region}","${params.ecr_repo_name}")
               }
            }
        }
/*     stage('Docker Image Scan: trivy '){
         when { expression {  params.action == 'create' } }
            steps{
               script{                   
                   dockerImageScan("${params.aws_account_id}","${params.region}","${params.ecr_repo_name}")
               }
            }
        } */
    stage('Docker Image Push : ECR '){
         when { expression {  params.action == 'create' } }
            steps{
               script{

                   //dockerImagePush("${params.aws_account_id}","${params.region}","${params.ecr_repo_name}")
                   sh """
                    aws ecr get-login-password --region ${params.region} | docker login --username AWS --password-stdin ${params.aws_account_id}.dkr.ecr.${params.region}.amazonaws.com
                    docker push ${params.aws_account_id}.dkr.ecr.${params.region}.amazonaws.com/${params.ecr_repo}:latest
                    """
               }
            }
        }   
    stage('Docker Image Cleanup : ECR '){
         when { expression {  params.action == 'create' } }
            steps{
               script{
                   
                   dockerImageCleanup("${params.aws_account_id}","${params.region}","${params.ecr_repo_name}")
               }
            }
        } 
    stage('Create EKS Cluster : Terraform'){
            when { expression {  params.action == 'create' } }
            steps{
                script{

                    dir('eks_module') {
                      sh """                          
                          terraform init 
                          terraform plan -var 'access_key=$AWS_ACCESS_KEY_ID' -var 'secret_key=$AWS_SECRET_KEY_ID' -var 'region=${params.region}' --var-file=./config/terraform.tfvars
                          terraform apply -var 'access_key=$AWS_ACCESS_KEY_ID' -var 'secret_key=$AWS_SECRET_KEY_ID' -var 'region=${params.region}' --var-file=./config/terraform.tfvars --auto-approve
                      """
                  }
                }
            }
        }
        /* 
        stage('Connect to EKS '){
            when { expression {  params.action == 'create' } }
        steps{

            script{

                sh """
                aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
                aws configure set aws_secret_access_key "$AWS_SECRET_KEY_ID"
                aws configure set region "${params.region}"
                aws eks --region ${params.region} update-kubeconfig --name ${params.cluster}
                """
            }
        }
        } 
        stage('Deployment on EKS Cluster'){
            when { expression { params.action == 'create' } }
            steps{
                script{
                  
                  def apply = false

                  try{
                    input message: 'please confirm to deploy on eks', ok: 'Ready to apply the config ?'
                    apply = true
                  }catch(err){
                    apply= false
                    currentBuild.result  = 'UNSTABLE'
                  }
                  if(apply){

                    sh """
                      kubectl apply -f k8s/deployment.yaml
                    """
                  }
                }
            }
        }
        */

        /*
        stage('Docker Image Build'){
         when { expression {  params.action == 'create' } }
            steps{
               script{
                   
                   dockerBuild("${params.ImageName}","${params.ImageTag}","${params.DockerHubUser}")
               }
            }
        }
         stage('Docker Image Scan: trivy '){
         when { expression {  params.action == 'create' } }
            steps{
               script{
                   
                   dockerImageScan("${params.ImageName}","${params.ImageTag}","${params.DockerHubUser}")
               }
            }
        }
        stage('Docker Image Push : DockerHub '){
         when { expression {  params.action == 'create' } }
            steps{
               script{
                   
                   dockerImagePush("${params.ImageName}","${params.ImageTag}","${params.DockerHubUser}")
               }
            }
        }   
        stage('Docker Image Cleanup : DockerHub '){
         when { expression {  params.action == 'create' } }
            steps{
               script{
                   
                   dockerImageCleanup("${params.ImageName}","${params.ImageTag}","${params.DockerHubUser}")
               }
            }
        } */      
    }
}