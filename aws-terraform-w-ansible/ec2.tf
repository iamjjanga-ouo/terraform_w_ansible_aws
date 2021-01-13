resource "aws_instance" "web" {
  count = length(var.availability_zones)
  ami = var.aws_ami_name
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id = aws_subnet.public[count.index].id
  key_name = var.key_pair

  user_data = file("web_env.sh")

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
  depends_on = [aws_instance.ansible, aws_instance.web]

  connection {
    user = var.remote_user
    type = "ssh"
    host = aws_instance.ansible.public_ip
    private_key = file("~/.ssh/${var.key_pair}.pem")
    timeout = "10m"
  }

  provisioner "file" {
    source = "./ansible_env.sh"
    destination = "~/ansible_env.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash ansible_env.sh",
      "sudo dnf install ansible -y",
      "echo '[node]' > inventory",
      "echo '${aws_instance.web[0].private_ip} ansible_user=ec2-user' >> inventory",
      "echo '${aws_instance.web[1].private_ip} ansible_user=ec2-user' >> inventory",
      "echo -e 'n\n' | ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ''", # Automated ssh-keygen without passphrase -> "https://unix.stackexchange.com/questions/69314/automated-ssh-keygen-without-passphrase-how"
//      "sshpass -p ${var.ssh_password} scp -v -o StrictHostKeyChecking=no -o LogLevel=quiet /home/ec2-user/.ssh/id_rsa.pub ec2-user@${aws_instance.web[0].private_ip}:/home/ec2-user/",
//      "sshpass -p ${var.ssh_password} scp -v -o StrictHostKeyChecking=no -o LogLevel=quiet /home/ec2-user/.ssh/id_rsa.pub ec2-user@${aws_instance.web[1].private_ip}:/home/ec2-user/",
      "sshpass -p dkagh1. ssh-copy-id ${var.remote_user}@${aws_instance.web[0].private_ip} -o StrictHostKeyChecking=no",
      "sshpass -p dkagh1. ssh-copy-id ${var.remote_user}@${aws_instance.web[1].private_ip} -o StrictHostKeyChecking=no",
    ]
  }
}

//resource "null_resource" "ssh-copy-id" {
//  depends_on = [null_resource.install_ansible_env]
//  count = length(aws_instance.web)
//
//  connection {
//    user = var.remote_user
//    type = "ssh"
//    host = aws_instance.web[count.index].public_ip
//    private_key = file("~/.ssh/${var.key_pair}.pem")
//    timeout = "5m"
//  }
//
//  provisioner "remote-exec" {
//    inline = [
//      "cat id_rsa.pub | while read line; do echo $line; done >> ~/.ssh/authorized_keys",
//    ]
//  }
//}

resource "null_resource" "ansible-playbook" {
//  depends_on = [null_resource.ssh-copy-id]
  depends_on = [null_resource.install_ansible_env]

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
      #"ansible-playbook -i inventory auto_known_hosts.yml",
      #"ansible-playbook -i inventory auto_authorized_keys.yml -k",
      "ansible node -i inventory -m ping",
    ]
  }
}
