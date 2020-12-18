variable "region" {
  default     = "eu-west-1"
  description = "AWS region"
}

provider "aws" {
  version = ">= 2.28.1"
  region  = "eu-west-1"
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "equalexperts"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.6.0"

  name                 = "equalexperts-x-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  # public_subnet_tags = {
  #   kubernetes.io / role / elb = 1
  # }

}
