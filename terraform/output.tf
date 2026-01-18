output "jenkins_public_ip" {
  description = "Public IP of Jenkins server"
  value       = aws_instance.jenkins.public_ip
}

output "tomcat_public_ip" {
  description = "Public IP of Tomcat server"
  value       = aws_instance.tomcat.public_ip
}

output "jenkins_ssh_command" {
  description = "SSH command for Jenkins"
  value       = "ssh -i ${var.private_key_path} ubuntu@${aws_instance.jenkins.public_ip}"
}

output "tomcat_ssh_command" {
  description = "SSH command for Tomcat"
  value       = "ssh -i ${var.private_key_path} ubuntu@${aws_instance.tomcat.public_ip}"
}

