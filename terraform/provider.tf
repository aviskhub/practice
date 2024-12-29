terraform {
  backend "s3" {
    bucket = "state-terraform-core"
    key = "practice"
    region = "ap-south-1"
  }
}
provider "aws" {
  region = "us-east-1"
}