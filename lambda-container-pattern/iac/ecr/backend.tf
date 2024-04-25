terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "terraform-state-playground-kai"
    key    = "ecr/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
