[jenkins]
${jenkins_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/${key_file}.pem

[app_servers]
${tomcat_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/${key_file}.pem

[all:vars]
ansible_python_interpreter=/usr/bin/python3