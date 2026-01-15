variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_type_jenkins" {
  description = "Jenkins EC2 instance"
  default     = "t3.small"
}

variable "instance_type_tomcat" {
  description = "Tomcat EC2 instance"
  default     = "t3.small"
}

variable "key_name" {
  description = "glare247"
  type       = string
}
variable "my_ip" {
  description = "Your IP address for SSH access"
  type        = string
}
variable "private_key_path" {}