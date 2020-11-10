
terraform {
  backend "s3" {
    bucket = "jango-tfstate-2"
    region = "us-east-2"
  }
}
