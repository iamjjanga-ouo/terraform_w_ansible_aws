resource "aws_instance" "web" {
  count = length(var.availability_zones)
  ami = var.aws_ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id = aws_subnet.public[count.index].id
  key_name = var.key_pair

  user_data = file("./env/web_env.sh")

  tags = {
    Name = "WEB-${count.index}"
  }
}

# initialize db
resource "null_resource" "setup_db" {
  depends_on = [aws_db_instance.my_db] #wait for the db to be ready
  count = length(var.availability_zones)

  connection {
    user = var.remote_user
    type = "ssh"
    host = aws_instance.web[count.index].public_ip
    private_key = file("~/.ssh/${var.key_pair}.pem")
    timeout = "15m"
  }

  provisioner "remote-exec" {
    inline = [
      "touch ~/env_tmp",
      "echo 'DATABASE_PASS=${var.my_db_password}' >> env_tmp",
      "echo 'DATABASE_URL=${aws_db_instance.my_db[count.index].address}' >> env_tmp",
    ]
  }
}

resource "aws_instance" "ansible" {
  ami = var.aws_ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.ans_sg.id]
  subnet_id = aws_subnet.public[0].id
  key_name = var.key_pair

  tags = {
    Name = "ansible"
  }
}

resource "null_resource" "install_ansible_env" {
  depends_on = [aws_instance.ansible, null_resource.setup_db]

  connection {
    user = var.remote_user
    type = "ssh"
    host = aws_instance.ansible.public_ip
    private_key = file("~/.ssh/${var.key_pair}.pem")
    timeout = "10m"
  }

  provisioner "file" {
    source = "./env/ansible_env.sh"
    destination = "~/ansible_env.sh"
  }

  provisioner "file" {
    source = "./ansible"
    destination = "~/"
  }

  provisioner "remote-exec" {
    inline = [
      "bash ansible_env.sh",
      "sudo dnf install ansible -y",
      "echo '[node]' > inventory",
      "echo 'web1 ansible_host=${aws_instance.web[0].private_ip}' >> inventory",
      "echo 'web2 ansible_host=${aws_instance.web[1].private_ip} ansible_user=ec2-user hostname=web2' >> inventory",
      "echo -e 'n\n' | ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ''", # Automated ssh-keygen without passphrase -> "https://unix.stackexchange.com/questions/69314/automated-ssh-keygen-without-passphrase-how"
      "sshpass -p ${var.ssh_password} ssh-copy-id ${var.remote_user}@${aws_instance.web[0].private_ip} -o StrictHostKeyChecking=no -o LogLevel=quiet",
      "sshpass -p ${var.ssh_password} ssh-copy-id ${var.remote_user}@${aws_instance.web[1].private_ip} -o StrictHostKeyChecking=no -o LogLevel=quiet",
    ]
  }
}

resource "null_resource" "ansible-playbook" {
  depends_on = [null_resource.install_ansible_env,
                null_resource.setup_db,
                local_file.tf_ansible_nginx_vars,
                local_file.tf_ansible_mysql_vars]

  connection {
    user = var.remote_user
    type = "ssh"
    host = aws_instance.ansible.public_ip
    private_key = file("~/.ssh/${var.key_pair}.pem")
    timeout = "20m"
  }

  provisioner "remote-exec" {
    inline = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ansible node -i inventory -m ping",
      "ansible-playbook -i inventory ansible/main.yml",
    ]
  }
}

