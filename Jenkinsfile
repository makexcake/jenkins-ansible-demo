pipeline {

    /*
    The following must be configured on jenkins server:
    - jenkins plugins: ssh agent, ssh pipeline steps
    - log into aws account on ansible server
    - set docker password as env var DOCKER_PASS
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
        
        stage("Execute ansible playbook") {
            steps {

                script {
                    echo "executing ansible playbook..."

                    def remote = [:]
                    remote.name = "ansible-server"
                    remote.host = env.ANSIBLE_SERVER
                    remote.allowAnyHosts = true

                    withCredentials([sshUserPrivateKey(credentialsId: "ansible-key", keyFileVariable: 'keyFile', usernameVariable: 'user')]) {
                        remote.user = user
                        remote.identityFile = keyfile
                        sshCommand remote: remote, command: '''ansible-playbook deploy-docker.yaml -e docker_pass=${DOCKER_PASS}'''
                    }                    
                }
            }            
        }
    }
}