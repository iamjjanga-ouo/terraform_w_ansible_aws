#################################################
# Variables to configure (User input Variables) #
#################################################
//variable "aws_access_key" {}
//variable "aws_secret_key" {}


#################################################
###### Provisioned Variables (Can modify) #######
#################################################
variable "aws_region" {
  default = "ap-northeast-2"
}

variable "vpc_name" {
  default = "main"
}

variable "aws_ami_name" {
  # default = "ami-d39a02b5" # ubuntu 16.04
  default = "ami-07270d166cdf39adc" # RHEL8
}

variable "instance_type" {
  default = "t2.micro"
}

# User to log in to instances and perform install
# This is independent upon the AMI you use, for AWS default User name
# Ubuntu -> ubuntu
# Another -> ec2-user
variable "remote_user" {
  # default = "ubuntu"
  default = "ec2-user"
}

# Desired AZs, must have 2
variable "zones" {
  type = list(string)
  default = ["a","c"]
}

# Path to your public key, which will be used to log in to
variable "public_key" {
  default = "~/.ssh/id_rsa.pub"
}

# Path to your private key that matches your public key
variable "private_key" {
  default = "~/.ssh/id_rsa"
}

variable "key_pair" {
  default = "seoul"
}

#######################################################
## Editable Ansible installation-specific variables ###
#######################################################
variable "host_label" {
  default = "host"
}
variable "cidr_numeral" {
  description = "VPC CIDR numeral (10.x.0.0/16) "
}

variable "cidr_numeral_public" {
  description = "Public CIDR"
  default = {
    "0" = "0"
    "1" = "16"
    "2" = "32"
  }
}

variable "cidr_numeral_private" {
  description = "Private CIDR"
  default = {
    "0" = "48"
    "1" = "64"
    "3" = "80"
  }
}

variable "cidr_numberal_db_private" {
  description = "DB Private CIDR"
  default = {
    "0" = "96"
    "1" = "112"
    "2" = "128"
  }
}


variable "availability_zones" {
  type = list(string)
  description = "Availability zone with a and c (because of t2.micro is only available in ap-northeast-2a,2c"
}

variable "ssh_password" {
  default = "dkagh1."
}

//variable "ssl_arn" {
//  description = "SSL arn, input with your arn using -var option"
//}