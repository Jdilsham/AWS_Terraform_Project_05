variable "aws_region" {
  description = "AWS region to deploy resources"
  type = string
  default = "us-east-1"
}

variable "project_name" {
  description = "Project name for tagging"
  type = string
  default = "terraform-webapp"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type = string
  default = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type = string
  default = "t2.micro"
}

variable "key_pair_name" {
  description = "Name of the existing key pair to use for EC2 instances"
  type = string
}