data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0.????????.?-x86_64-gp2"] # Amazon Linux 2.0버전 간 bug fix 등의 업데이트 문제가 있어도 AMI를 가져올 수 있음.
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

  user_data = "${file("install_nginx_php.sh")}"

  tags = {
    Name = "WEB-${count.index}"
  }
}