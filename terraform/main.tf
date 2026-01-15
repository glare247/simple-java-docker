provider "aws" {
  region = "us-east-1"  # Choose your desired AWS region
}


#vpc 

resource "aws_vpc" "java_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

#gateway
resource "aws_internet_gateway" "java_gw" {
  vpc_id = aws_vpc.java_vpc.id

  tags = {
    Name = "java_gw"
  }
}
#subnet
resource "aws_subnet" "java_subnet" {
  vpc_id     = aws_vpc.java_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "java_subnet"
  }
}
#routing table
resource "aws_route_table" "java_rt" {
  vpc_id = aws_vpc.java_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.java_gw.id
  }  
}
# routing table association 
resource "aws_route_table_association" "java_rta" {
  subnet_id      = aws_subnet.java_subnet.id
  route_table_id = aws_route_table.java_rt.id
}

# Jenkins secuirty group

resource "aws_security_group" "jenkins_sg" {
  name   = "jenkins_sg"
  vpc_id = aws_vpc.java_vpc.id

  tags = {
    Name = "jenkins_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_ssh" {
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv4         = "${var.my_ip}/32"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_8080" {
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv4         = "${var.my_ip}/32"
  from_port         = 8080
  to_port           = 8080
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "jenkins_egress" {
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

#tomcat security group
resource "aws_security_group" "tomcat_sg" {
  name   = "tomcat_sg"
  vpc_id = aws_vpc.java_vpc.id

  tags = {
    Name = "tomcat_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "tomcat_ssh" {
  security_group_id = aws_security_group.tomcat_sg.id
  cidr_ipv4         = "${var.my_ip}/32"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "tomcat_8080" {
  security_group_id = aws_security_group.tomcat_sg.id
  cidr_ipv4         = "${var.my_ip}/32"
  from_port         = 8080
  to_port           = 8080
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "tomcat_egress" {
  security_group_id = aws_security_group.tomcat_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

#Jenkins EC2 instance
resource "aws_instance" "jenkins" {
  ami                         = "ami-0ecb62995f68bb549"
  instance_type               = "t3.small"
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.java_subnet.id
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "jenkins_server"
  }
}
#tomcat EC2 instance
resource "aws_instance" "tomcat" {
  ami                         = "ami-0ecb62995f68bb549"
  instance_type               = "t3.small"
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.java_subnet.id
  vpc_security_group_ids      = [aws_security_group.tomcat_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "tomcat_server"
  }
}
#ansible inventory
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    jenkins_ip = aws_instance.jenkins.public_ip
    tomcat_ip  = aws_instance.tomcat.public_ip
    key_file   = var.private_key_path
  })

  filename        = "${path.module}/../ansible/inventory/hosts.ini"
  file_permission = "0644"
}
