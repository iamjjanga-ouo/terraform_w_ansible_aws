# Region
output "aws_region" {
  value = var.aws_region
}

# VPC
output "vpc_name" {
  value = var.vpc_name
}

output "vpc_id" {
  value = aws_vpc.main.id
}

# Availability Zones
output "availability_zones" {
  description = "list of Availability zones in VPC"
  value = var.availability_zones
}

# Public Subnets
output "public_subnets" {
  description = "List of public subnets in VPC"
  value = aws_subnet.public.*.id
}

# private Subnets
output "private_subnets" {
  description = "List of private subnets in VPC"
  value = aws_subnet.private.*.id
}