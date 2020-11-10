# Provider Configuration
provider "aws" {
  version = ">= 2.41, < 4.0"
  region  = var.region
}
# Using these data sources allows the configuration to be
# generic for any region.
# provider "aws" {
#   alias  = "us-east-1"
#   region = "us-east-1"
# }



data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

# Not required: currently used in conjuction with using
# icanhazip.com to determine local workstation external IP
# to open EC2 Security Group access to the Kubernetes cluster.
# See workstation-external-ip.tf for additional information.
provider "http" {}
