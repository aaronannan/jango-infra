cluster_version    = "1.17"
cluster_name       = "jango-production"
key_name           = "sf_key"
availability_zones = ["us-east-2a", "us-east-2b"]
region             = "us-east-2"
Environment        = "production"
cidr               = "10.11.0.0/16"
private_subnets    = ["10.11.32.0/19", "10.11.0.0/22", "10.11.64.0/19", "10.11.4.0/22"]
public_subnets     = ["10.11.8.0/22", "10.11.16.0/22", "10.11.12.0/22", "10.11.20.0/22"]
domain             = "prod.safe.internal"
username           = "admin"
password           = "safeishealth"
bucket_name        = "jango-tfstate-2"
