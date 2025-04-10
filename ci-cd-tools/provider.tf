terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.84.0"
    }
  }

  backend "s3" {
    bucket = "82s-dont-tf-remote-state-dev"
    key = "expense-cicd-tools-don"
    region = "us-east-1"
    dynamodb_table = "82s-dont-tf-remote-state-dev"
    
  }
}
provider "aws" {
    #configuration settings
    region = "us-east-1"
}