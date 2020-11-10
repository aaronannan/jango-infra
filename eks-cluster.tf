#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#
resource "aws_key_pair" "sf_key" {
  key_name   = var.key_name
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDItshIxvf/abwI1rR96alhUf91gP9uIyg2VjSHC1GeBNMc3Cd9j7TtQnhpoORVi+CPjkJykwSkgnrwCz7gOibkOG+6Ds1svkkS8DbGG6T/TEvp7oPl5p/nl76h/Mn9IlpWEUYjYNA7ZCqAcmiV4dd6paFe90NSj/FPviAbcuMkjbmbZXqgcPS0hglVZAJheml9OqEPss/BOj2oJzp6t0bJBmWRN0OnmBWQ2W6eyLdeKx4xtimnoZlfWg9+sR8H07+BBdkk/yJ6lRtpDhc4pbut4IWhc1NkgWC6dJ91oix2dG7zYcHjug2mjPQ0t/ssutC03yqr6fwH0jGC72gLWVpzP26SmrRlv8vhUhsnRWoEySHHwx8uK60CPEPVNSu+7oLhdkDKn5bsVN69DIfc58T9aalRSEHVptKglOy2TsNbMVB90PAEjnkf27oDmvrbLuc7HF00dWPqkn+ooHWgC1sq//qFEM3dtET9mzuS8sTa1+0zXIxzzKmJxDjH+HprWs7kJLYJji8yvHDgQArI7utKkJ3n6qQYzehO1VuPVRadk0UDIuovsznkbxxeh1rWBDh362PhvD4QOaYkrrTxqZqxtT7PhXV2ojdt4hmB27QX0lbiOf8HAKb4aLljd1lIiaT6pdyU2x8eeBgv33CQX3xXKBh7fhUWcSDDRtzBqPKIDQ== safehealth.me"
}

resource "aws_iam_role" "admin-role" {
  name = "admin-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "admin-role-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.admin-role.name
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnets         = module.vpc.private_subnets

  tags = {
    Environment = "prod"
  }

  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      additional_userdata           = "label"
      asg_desired_capacity          = 1
      max_size                      = 1
      min_size                      = 1
      key_name                      = var.key_name
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      subnet_ids                    = module.vpc.private_subnets
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t2.medium"
      additional_userdata           = "label"
      key_name                      = var.key_name
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity          = 1
      max_size                      = 1
      min_size                      = 1
      subnet_ids                    = module.vpc.private_subnets
    },
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "1.11.1"
}
