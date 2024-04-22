terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "terraform-state-playground-kai"
    key    = "app-infra/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
