variable "aws_region" {
  default = "ap-northeast-2"
}

variable "vpc_name" {}

variable "cidr_numeral" {
  description = "VPC CIDR numeral (10.x.0.0/16) "
}

variable "cidr_numeral_public" {
  description = "VPC Public CIDR"
  default = {
    "0" = "0"
    "1" = "16"
    "2" = "32"
  }
}

variable "cidr_numeral_private" {
  description = "VPC Private CIDR"
  default = {
    "0" = "48"
    "1" = "64"
    "3" = "80"
  }
}

variable "availability_zones" {
  type = list(string)
  description = "Availability zone with a and c (because of t2.micro is only available in ap-northeast-2a,2c"
}

variable "key_pair" {
  default = "seoul"
}