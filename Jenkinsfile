@Library('jenkins-shared-lib') _
pipeline {
    agent any

    stages{

        stage('Git Checkout'){
            steps{
                gitCheckout(
                branch: "master",
                url: "https://github.com/yogeshk04/hello-springboot.git"
            )
            }            
        }

        stage('Unit test Maven'){
            steps{
                script{
                    mvnTest()
                }
            }            
        }
    }
}