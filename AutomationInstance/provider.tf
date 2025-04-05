terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.84.0"
    }
  }

  backend "s3" {
    bucket = "82s-remote-state"
    key = "expense-cicd-tools"
    region = "us-east-1"
    dynamodb_table = "82s-locking"
    
  }
}
provider "aws" {
    #configuration settings
    region = "us-east-1"
}