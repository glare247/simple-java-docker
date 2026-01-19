[jenkins]
${jenkins_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${key_file}

[app_servers]
${tomcat_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${key_file}

[all:vars]
ansible_python_interpreter=/usr/bin/python3
