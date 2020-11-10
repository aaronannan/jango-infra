
locals {
  cluster_name = "jango-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.58.0"

  name                 = "jango-${var.Environment}-vpc"
  cidr                 = var.cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

resource "aws_route53_zone" "jango_private" {
  name = var.domain

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

resource "aws_lb" "jango" {
  name               = "jango-${var.Environment}-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = module.vpc.private_subnets

  enable_deletion_protection = true

  tags = {
    Environment = "dev"
  }
}

resource "aws_vpc_endpoint_service" "jango" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.jango.arn]
  # private_dns_name           = aws_route53_zone.jango_private

  tags = {
    Environment = var.Environment
  }
}
