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

module "web-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = "${var.project_name}-web-sg"
  description = "Security group for web instances"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.ssh_allowed_cidr
      description = "Allow SSH from my IP"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow HTTP from my IP"
    }
  ]

  egress_rules = ["all-all"]

  tags = {
    Project = var.project_name
  }
}


module "web_ec2"{
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "~>6.0"

  name = "${var.project_name}-web-server"

  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  monitoring = false
  associate_public_ip_address = true

  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.web-sg.security_group_id]

  user_data = <<-EOF
               #!/bin/bash
              yum update -y
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              EOF
  tags = {
    Project = var.project_name
  }
}