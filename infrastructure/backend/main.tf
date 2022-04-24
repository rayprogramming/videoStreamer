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
module "users" {
  source  = "rayprogramming/rayprogramming-cognito-auth/aws"
  version = "1.0.1"
  project = var.project
  env     = var.env
  zone_id = var.zoneid
}
