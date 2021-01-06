
resource "aws_instance" "web" {
  count = length(var.availability_zones)
  ami = var.ami_rhel
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id = aws_subnet.public[count.index].id
  key_name = var.key_pair

//  user_data = file("install_nginx_php.sh")

  tags = {
    Name = "WEB-${count.index}"
  }
}