terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.66.0"
    }
  }

  backend "s3" {
    bucket = "82s-dont-tf-remote-state-dev"
    key = "vpc infra"
    region = "us-east-1"
    dynamodb_table = "82s-dont-tf-remote-state-dev"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}