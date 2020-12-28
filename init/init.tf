provider "aws" {
  region = "ap-northeast-2"
  version = "~> 3.22.0"
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "tfstate-iamjjanga"

  versioning {
    enabled = true # Prevent from deleting tfstate file
  }
}