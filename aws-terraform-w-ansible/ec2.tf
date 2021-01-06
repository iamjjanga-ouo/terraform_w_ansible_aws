
resource "aws_instance" "web" {
  count = length(var.availability_zones)
  ami = var.aws_ami_name
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id = aws_subnet.public[count.index].id
  key_name = var.key_pair

//  user_data = file("install_nginx_php.sh")

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

resource "null_resource" "install_ansible" {
  connection {
    user = var.remote_user
    type = "ssh"
    host = aws_instance.ansible.public_ip
    private_key = file("~/.ssh/${var.key_pair}.pem")
    timeout = "2m"
  }

  provisioner "file" {
  source      = "./test.yml"
  destination = "~/test.yml"
  }

  # install python3
  provisioner "remote-exec" {
    inline = [
      "sudo dnf update -y",
      "sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y",
      "sudo dnf install python3 -y",
      "sudo dnf install ansible -y",
      "echo '[node]' > inventory",
      "echo '${aws_instance.web[0].public_ip} ansible_ssh_user=ec2-user ansible_ssh_private_key_file=~/.ssh/${var.key_pair}.pem' >> inventory",
      "echo '${aws_instance.web[1].public_ip} ansible_ssh_user=ec2-user ansible_ssh_private_key_file=~/.ssh/${var.key_pair}.pem' >> inventory",
      "ANSIBLE_HOST_EKY_CHECKING=False",
      "ansible-playbook -i inventory test.yml",
    ]
  }
}



