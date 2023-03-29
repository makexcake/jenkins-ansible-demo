pipeline {

    /*
    The following must be configured on jenkins server:
    - jenkins plugin: ssh agent
    - jenkins plugin: ssh pipeline steps
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
                        sh 'scp -o StrictHostChecking=no ansible/* root@$ANSIBLE_SERVER:/root'
                    }

                    echo "copying ec2 key to ansible server..."

                }                   
            }
        }
    }
}