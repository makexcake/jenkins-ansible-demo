pipeline {

    /*
    The following must be configured on jenkins server:
    - jenkins plugin: ssh agent
    - jenkins plugin: ssh pipeline steps
    - log into aws account on ansible server
    - 
    */

    agent any

    environment {
        ANSIBLE_SERVER = "164.90.217.29"
    }
    stages {

        // cp nessesary files to the ansible server
        stage("Copy file to ansible server") {
            steps {

                script {

                    echo "copying project files to ansible server..."
                    sshagent(['ansible-key']) {
                        //copy project files to the ansible server
                        sh "scp -o StrictHostChecking=no ansible/* root@${ANSIBLE_SERVER}:/root"
                    }

                    echo "copying ec2 key to ansible server..."
                    // copy ec2 server key to ansible server
                    withCredentials([sshUserPrivateKey(credentialsId: "ec2-key", keyFileVariable: 'keyFile', usernameVariable: 'user')]) {
                        sh "scp ${keyfile} root@${ANSIBLE_SERVER}:/root/MyKeyPair.pem"
                    }
                }                   
            }
        }
    }
}