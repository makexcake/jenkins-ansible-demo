# Jenkins-ansible demo
The following repo is a demo project written by @makexcake while completing Tech World With Nana DevOps bootcamp exercises.

## Description
The project requires two servers, one for the jenkins machine and the other is ansible dedicated server.

Terraform folder include terraform file for provisioning an ec2 instance on which the pipeline will configure docker and setting up java-mysql app from the exercises.

The pipeline includes the following steps: 
* Copying keys and project files to the ansible server
* executing the playbook on the ansible machine.
### The playbook:
* Installes python3, Docker and docker-compose on the dedicated ec2 server
* Copying the docker-compose file to the instance
* Running docker-compose file which set up java-gradle and mysql containers