provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.5.1"

  name = var.project_name
  cidr = var.vpc_cidr

  azs            = [var.aws_region]
  public_subnets = [var.public_subnet_cidrs]

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Project = var.project_name
  }
}