resource "aws_db_instance" "my_db" {
  count = length(var.availability_zones)
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "admin"
  password             = var.my_db_password
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.id
  availability_zone = element(var.availability_zones, count.index)

  # ERROR : DB Instance FinalSnapshotIdentifier is required when a final snapshot is required -> https://github.com/hashicorp/terraform-provider-aws/issues/2588
  skip_final_snapshot = true
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