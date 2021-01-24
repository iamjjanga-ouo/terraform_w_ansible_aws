terraform {
  backend "s3" {
    bucket = "tfstate-iamjjanga"
    key = "terraform_w_aws/main/terraform.tfstate"
    region = "ap-northeast-2"
    encrypt = true
    dynamodb_table = "terraform-lock"
  }
}