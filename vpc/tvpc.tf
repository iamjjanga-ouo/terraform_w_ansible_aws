#######
# VPC
#######
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "main_vpc"
  }
}

#########
## Subnet
#########
# Public subnet x2
resource "aws_subnet" "public_subnet_1" {
  cidr_block = "10.0.0.0/24"
  vpc_id = aws_vpc.main.id
  
  availability_zone = "ap-northeast-2a"
  
  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "public_subnet_2" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.main.id
  
  availability_zone = "ap-northeast-2c"
  
  tags = {
    Name = "public_subnet"
  }
}

# private subnet x2
resource "aws_subnet" "private_subnet_1" {
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_vpc.main.id
  
  availability_zone = "ap-northeast-2a"
  
  tags = {
    Name = "private_subnet"
  }
}

resource "aws_subnet" "private_subnet_2" {
  cidr_block = "10.0.3.0/24"
  vpc_id = aws_vpc.main.id
  
  availability_zone = "ap-northeast-2c"
  
  tags = {
    Name = "private_subnet"
  }
}

##################
## Internet Gateway
##################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main_igw"
  }
}

################
## Route Table
################

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table_association" "public_route_table_association_1" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.public_subnet_1.id
}

resource "aws_route_table_association" "public_route_table_association_2" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.public_subnet_2.id
}

# Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private_route_table"
  }
}

resource "aws_route_table_association" "private_route_table_association_1" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id = aws_subnet.private_subnet_1.id
}

resource "aws_route_table_association" "private_route_table_association_2" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id = aws_subnet.private_subnet_2.id
}