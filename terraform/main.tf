terraform {
    required_version = ">=0.12"
    backend "s3" {
      bucket = "nanas-demos"
      key = "dynamic-env-demo/terraform.tfstate"
      region = "eu-central-1"
    }   
}

provider "aws" {}

variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
variable instance_type {}
//ansible vars
variable ssh_private_key {}
variable playbook_dir {}


//create vpc 
resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    enable_dns_hostnames = true

    tags = {
        Name: "${var.env_prefix}-vpc"
    }
}

//create subnet
resource "aws_subnet" "myapp-subnet-1" {
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone

    tags = {
        Name: "${var.env_prefix}-subnet-1"
    }
}

//create internet gateway
resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = aws_vpc.myapp-vpc.id

    tags = {
        Name: "${var.env_prefix}-igw"
    }
}

//create route table
resource "aws_route_table" "myapp-route-table" {
    vpc_id = aws_vpc.myapp-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
    }

    tags = {
        Name: "${var.env_prefix}-rtb"
    }
}

//associate route table with subnet
resource "aws_route_table_association" "a-rtb-subnet" {
    subnet_id = aws_subnet.myapp-subnet-1.id
    route_table_id = aws_route_table.myapp-route-table.id
}

//create security group
resource "aws_security_group" "myapp-sg" {
    name = "myapp-sg"
    vpc_id = aws_vpc.myapp-vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 0
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }

    tags = {
        Name: "${var.env_prefix}-sg"
    }
}

//fetch lastest OS image ami
data "aws_ami" "lastest-amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

//output os ami id
output "aws_ami_id" {
    value = data.aws_ami.lastest-amazon-linux-image.id
}

//create ec2 instance
resource "aws_instance" "myapp-server-0" {
    ami = data.aws_ami.lastest-amazon-linux-image.id
    instance_type = var.instance_type

    subnet_id = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids = [aws_security_group.myapp-sg.id]
    availability_zone = var.avail_zone

    associate_public_ip_address = true
    key_name = "MyKeyPair"
    

    tags = {
        Name = "${var.env_prefix}-server"
    }
}

resource "aws_instance" "myapp-server-1" {
    ami = data.aws_ami.lastest-amazon-linux-image.id
    instance_type = var.instance_type

    subnet_id = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids = [aws_security_group.myapp-sg.id]
    availability_zone = var.avail_zone

    associate_public_ip_address = true
    key_name = "MyKeyPair"
    

    tags = {
        Name = "${var.env_prefix}-server"
    }
}

resource "aws_instance" "myapp-server-2" {
    ami = data.aws_ami.lastest-amazon-linux-image.id
    instance_type = "t2.small"

    subnet_id = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids = [aws_security_group.myapp-sg.id]
    availability_zone = var.avail_zone

    associate_public_ip_address = true
    key_name = "MyKeyPair"
    

    tags = {
        Name = "${var.env_prefix}-server"
    }
}

/*
resource "null_resource" "configure-server" {
    triggers = {
      "trigger" = "aws_instance.myapp-server.public_ip"
    }

    provisioner "local-exec" {
        working_dir = "../"
        command = "ansible-playbook --inventory ${aws_instance.myapp-server.public_ip}, --private-key ${var.ssh_private_key} --user ec2-user deploy-docker.yaml"
    }    
}
*/

/*
//output ec2 instence public ip to ssh
output "ec2_public_ip" {
    value = aws_instance.myapp-server.public_ip
}
*/







