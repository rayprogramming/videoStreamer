terraform {
  required_version = "~> 1.1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "rayprogramming-terraform"
    key    = "video"
    region = "us-east-2"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}
provider "aws" {
  region = "us-east-1"
  alias  = "east-1"
}

data "aws_route53_zone" "selected" {
  name = var.root_domain
}
module "frontend" {
  source  = "git@github.com:rayprogramming/terraform-aws-videoStreamer-cloudfront.git"
  name    = "video"
  domain  = data.aws_route53_zone.selected.name
  zone_id = data.aws_route53_zone.selected.zone_id
}

module "users" {
  source  = "git@github.com:rayprogramming/terraform-aws-cognito-auth.git"
  project = "videoStreamer"
  env     = "dev"
  zone_id = data.aws_route53_zone.selected.zone_id
}
