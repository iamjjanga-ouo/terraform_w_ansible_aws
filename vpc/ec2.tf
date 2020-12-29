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
  subnet_id = aws_subnet.public[count.index].id
  key_name = var.key_pair

  tags = {
    Name = "WEB-${count.index}"
  }
}