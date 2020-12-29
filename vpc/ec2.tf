data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0.????????.?-x86_64-gp2"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "web" {
  count = length(var.availability_zones)
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id = aws_subnet.public[count.index].id
  key_name = var.key_pair

  user_data = <<EOF
          #!/bin/bash
          sudo amazon-linux-extras install nginx1 -y
          sudo systemctl enable --now nginx
          echo "<h1>Deployed via Terraform</h1>" | sudo tee /usr/share/nginx/html/index.html
  EOF

  tags = {
    Name = "WEB-${count.index}"
  }
}