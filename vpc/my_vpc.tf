#######
# VPC
#######
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "${var.vpc_name}_vpc"
  }
}

##################
## Internet Gateway
##################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}_igw"
  }
}

####################
## Public Subnet x 2
####################
resource "aws_subnet" "public" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.main.id

  cidr_block = "10.${var.cidr_numeral}.${var.cidr_numeral_public[count.index]}.0/20"
  availability_zone = element(var.availability_zones, count.index)

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}_public_${count.index}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}_public_rt"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.availability_zones)
  route_table_id = aws_route_table.public.id
  subnet_id = element(aws_subnet.public.*.id, count.index)
}

####################
## Private Subnet x 2
####################
resource "aws_subnet" "private" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.main.id

  cidr_block = "10.${var.cidr_numeral}.${var.cidr_numeral_private[count.index]}.0/20"
  availability_zone = element(var.availability_zones, count.index)
  
  tags = {
    Name = "${var.vpc_name}_private_${count.index}"
    Network = "private"
  }
}

# Private route table x 2
resource "aws_route_table" "private" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}_private_rt_${count.index}"
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.availability_zones)
  route_table_id = element(aws_route_table.private.*.id, count.index)
  subnet_id = element(aws_subnet.private.*.id, count.index)
}