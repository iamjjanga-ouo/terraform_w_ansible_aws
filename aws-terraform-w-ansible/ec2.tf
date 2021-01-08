resource "aws_instance" "web" {
  count = length(var.availability_zones)
  ami = var.aws_ami_name
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id = aws_subnet.public[count.index].id
  key_name = var.key_pair

  user_data = file("install_env.sh")

  tags = {
    Name = "WEB-${count.index}"
  }
}

resource "aws_instance" "ansible" {
  ami = var.aws_ami_name
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.ans_sg.id]
  subnet_id = aws_subnet.public[0].id
  key_name = var.key_pair

  tags = {
    Name = "ansible"
  }
}

resource "null_resource" "install_ansible_env" {
  depends_on = [aws_instance.ansible]

  connection {
    user = var.remote_user
    type = "ssh"
    host = aws_instance.ansible.public_ip
    private_key = file("~/.ssh/${var.key_pair}.pem")
    timeout = "2m"
  }

  provisioner "file" {
  source      = "./auto_known_hosts.yml"
  destination = "~/auto_known_hosts.yml"
  }

  provisioner "file" {
    source = "./auto_authorized_keys.yml"
    destination = "~/auto_authorized_keys.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dnf update -y",
      "sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y",
      "sudo dnf install python3 -y",
      "sudo dnf install ansible -y",
      "echo '${aws_instance.web[0].private_ip}' | sudo tee -a /etc/hosts",
      "echo '${aws_instance.web[1].private_ip}' | sudo tee -a /etc/hosts",
      "echo '[node]' > inventory",
      "echo '${aws_instance.web[0].private_ip} ansible_user=ec2-user' >> inventory",
      "echo '${aws_instance.web[1].private_ip} ansible_user=ec2-user' >> inventory",
      "ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ''", # Automated ssh-keygen without passphrase -> "https://unix.stackexchange.com/questions/69314/automated-ssh-keygen-without-passphrase-how"
      "sshpass -p ${var.ssh_password} scp -o StrictHostKeyChecking=no /home/ec2-user/.ssh/id_rsa.pub ec2-user@${aws_instance.web[0].private_ip}:/home/ec2-user/",
      "sshpass -p ${var.ssh_password} scp -o StrictHostKeyChecking=no /home/ec2-user/.ssh/id_rsa.pub ec2-user@${aws_instance.web[1].private_ip}:/home/ec2-user/",
    ]
  }
}

resource "null_resource" "ssh-copy-id" {
  depends_on = [null_resource.install_ansible_env]
  count = length(aws_instance.web)

  connection {
    user = var.remote_user
    type = "ssh"
    host = aws_instance.web[count.index].public_ip
    private_key = file("~/.ssh/${var.key_pair}.pem")
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "cat id_rsa.pub | while read line; do echo $line; done >> ~/.ssh/authorized_keys",
    ]
  }
}

resource "null_resource" "ansible-playbook" {
  depends_on = [null_resource.ssh-copy-id]

  connection {
    user = var.remote_user
    type = "ssh"
    host = aws_instance.ansible.public_ip
    private_key = file("~/.ssh/${var.key_pair}.pem")
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ansible-playbook -i inventory auto_known_hosts.yml",
      #"ansible-playbook -i inventory auto_authorized_keys.yml -k",
      "ansible node -i inventory -m ping",
    ]
  }
}
