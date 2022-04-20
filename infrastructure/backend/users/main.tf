terraform {
  required_version = "~> 1.1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  alias  = "east-1"
}

locals {
  module_name = "users"
}

data "aws_route53_zone" "selected" {
  zone_id = var.zoneid
}


data "terraform_remote_state" "iam" {
  backend = "s3"

  config = {
    bucket     = "rayprogramming-terraform"
    key        = "iam"
    kms_key_id = "alias/TwoRivers-sym"
    region     = "us-east-2"
  }
}
