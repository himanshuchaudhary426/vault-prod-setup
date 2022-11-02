terraform {
  required_version = ">= 1.2.1"

  required_providers {
    aws = ">= 3.0.0, < 4.0.0"
  }

  backend "s3" {
    bucket = "demo-bucket-426"
    key    = "terraform/vault/terraform.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = var.aws_region
}