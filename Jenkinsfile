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
        string(name: 'ECR_REPO_NAME', description: "name of the ECR", defaultValue: 'ars-marketplace')
        //string(name: 'cluster', description: "name of the EKS Cluster", defaultValue: 'demo-cluster1')
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
                   dockerBuild("${params.aws_account_id}","${params.region}","${params.ECR_REPO_NAME}")
               }
            }
        }
    stage('Docker Image Scan: trivy '){
         when { expression {  params.action == 'create' } }
            steps{
               script{                   
                   dockerImageScan("${params.aws_account_id}","${params.region}","${params.ECR_REPO_NAME}")
               }
            }
        }
        stage('Docker Image Push : ECR '){
         when { expression {  params.action == 'create' } }
            steps{
               script{
                   
                   dockerImagePush("${params.aws_account_id}","${params.region}","${params.ECR_REPO_NAME}")
               }
            }
        }   
        stage('Docker Image Cleanup : ECR '){
         when { expression {  params.action == 'create' } }
            steps{
               script{
                   
                   dockerImageCleanup("${params.aws_account_id}","${params.region}","${params.ECR_REPO_NAME}")
               }
            }
        } 
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