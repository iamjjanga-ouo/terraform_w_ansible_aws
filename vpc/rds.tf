resource "aws_db_instance" "rds" {
  count = length(var.availability_zones)
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "admin"
  password             = "dkagh1.."
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.id
  availability_zone = element(var.availability_zones, count.index)
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  #count = length(var.availability_zones)
  name       = "rds_sg"
  #subnet_ids = list(aws_subnet.db_private[count.index].id)
  subnet_ids = aws_subnet.db_private.*.id
  tags = {
    Name = "${var.vpc_name}_rds_sg"
  }
}