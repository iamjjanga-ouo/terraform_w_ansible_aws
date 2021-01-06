provider "aws" {
  region = var.aws_region

//  access_key = var.aws_access_key
//  secret_key = var.aws_secret_key

  # or can use profile
  # profile = "<aws profile>"
}