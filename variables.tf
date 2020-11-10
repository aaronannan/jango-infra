#
# Variables Configuration
#
variable "cluster_version" {
  default = "1.17"
}

variable "cluster_name" {
  default = "jango-us-east-2-development"
}

variable "key_name" {
  default = "jango_key"
}

variable "availability_zones" {
  default = ["us-east-2a", "us-east-2b"]
}

variable "region" {
  default     = "us-east-2"
  description = "AWS region"
}

variable "Environment" {
  default = "general"
}

variable "cidr" {
  description = "cidr blocks for vpc"
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  default = ["10.0.7.0/24", "10.0.9.0/24", "10.0.5.0/24"]
}

variable "public_subnets" {
  default = ["10.0.13.0/24", "10.0.12.0/24", "10.0.11.0/24"]
}

variable "domain" {
  default = "general.safe.internal"
}
#database
variable "username" {
  default = "admin"
}

variable "password" {
  default = "safeishealth"
}
variable "bucket_name" {
  default = "jango-tfstate-2"
}
