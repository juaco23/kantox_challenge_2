#Requiring a minimum Terraform version to execute a configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.1"
    }
  }
  required_version = ">= 0.13"

  # backend "s3" {
  #   bucket         = "sample-bucket-for-a-poc"
  #   key            = "pop/terraform.tfstate"
  #   dynamodb_table = "sample-dynamo-for-a-poc"
  #   region         = "us-east-1"
  #   encrypt        = true
  # }
}

#The provider variables for used the services
provider "aws" {
  region  = "us-east-1"
}
