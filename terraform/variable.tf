variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type_jenkins" {
  description = "Jenkins EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "instance_type_tomcat" {
  description = "Tomcat EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "Name of the AWS EC2 key pair"
  type        = string
  default     = "glare247"
}

variable "my_ip" {
  description = "Your IP address for SSH access"
  type        = string
}

variable "private_key_path" {
  description = "Path to private key file for Ansible"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances (Ubuntu 22.04 LTS)"
  type        = string
}