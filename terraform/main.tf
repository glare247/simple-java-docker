provider "aws" {
  region = var.aws_region  # ✅ Using your variable
}

# -------------------
# VPC
# -------------------
resource "aws_vpc" "java_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Name = "java_vpc"
  }
}

# -------------------
# Internet Gateway
# -------------------
resource "aws_internet_gateway" "java_gw" {
  vpc_id = aws_vpc.java_vpc.id
  
  tags = {
    Name = "java_gw"
  }
}

# -------------------
# Subnet
# -------------------
resource "aws_subnet" "java_subnet" {
  vpc_id                  = aws_vpc.java_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "java_subnet"
  }
}

# -------------------
# Route Table
# -------------------
resource "aws_route_table" "java_rt" {
  vpc_id = aws_vpc.java_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.java_gw.id
  }
  
  tags = {
    Name = "java_rt"
  }
}

resource "aws_route_table_association" "java_rta" {
  subnet_id      = aws_subnet.java_subnet.id
  route_table_id = aws_route_table.java_rt.id
}

# -------------------
# Jenkins Security Group
# -------------------
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Security group for Jenkins"
  vpc_id      = aws_vpc.java_vpc.id
  
  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]  # ✅ Using your variable
  }
  
  ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]  # ✅ Using your variable
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "jenkins_sg"
  }
}

# -------------------
# Tomcat Security Group
# -------------------
resource "aws_security_group" "tomcat_sg" {
  name        = "tomcat_sg"
  description = "Security group for Tomcat"
  vpc_id      = aws_vpc.java_vpc.id
  
  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]  # ✅ Using your variable
  }
  
  ingress {
    description = "Tomcat HTTP from my IP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]  # ✅ Using your variable
  }
  
  # 🔥 CRITICAL: Allow Jenkins to deploy to Tomcat
  ingress {
    description     = "Tomcat HTTP from Jenkins"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.jenkins_sg.id]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "tomcat_sg"
  }
}

# -------------------
# Jenkins EC2
# -------------------
resource "aws_instance" "jenkins" {
  ami                         = var.ami_id                      # ✅ Using your variable
  instance_type               = var.instance_type_jenkins       # ✅ Using your variable
  key_name                    = var.key_name                    # ✅ Using your variable
  subnet_id                   = aws_subnet.java_subnet.id
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true
  
  tags = {
    Name = "jenkins_server"
  }
}

# -------------------
# Tomcat EC2
# -------------------
resource "aws_instance" "tomcat" {
  ami                         = var.ami_id                      # ✅ Using your variable
  instance_type               = var.instance_type_tomcat        # ✅ Using your variable
  key_name                    = var.key_name                    # ✅ Using your variable
  subnet_id                   = aws_subnet.java_subnet.id
  vpc_security_group_ids      = [aws_security_group.tomcat_sg.id]
  associate_public_ip_address = true
  
  tags = {
    Name = "tomcat_server"
  }
}

# -------------------
# Ansible Inventory
# -------------------
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    jenkins_ip = aws_instance.jenkins.public_ip
    tomcat_ip  = aws_instance.tomcat.public_ip
    key_file   = var.private_key_path  # ✅ Using your variable
  })
  
  filename        = "${path.module}/../ansible-config/hosts.ini"
  file_permission = "0644"
}