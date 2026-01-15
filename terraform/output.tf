output "jenkins_public_ip" {
    description = "public IP of jenkins server"
    value       =  aws_instance.jenkins.public_ip

}
output "jenkins_url" {
  description = "jenkins URL"
  value       = "http://${aws_instance.jenkins.public_ip}:8080" 

}

output "tomcat_public_ip" {
    description = "public IP of tomcat server"
    value       =  aws_instance.tomcat.public_ip

}

output "tomcat_url" {
  description = "tomcat URL"
  value       = "http://${aws_instance.tomcat.public_ip}:8080" 

}


