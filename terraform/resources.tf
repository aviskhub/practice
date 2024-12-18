resource "aws_vpc" "cluster-vpc" {
  cidr_block = "10.32.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "Cluster-vpc"
  }
}

locals {
  public-cidr_block = {
    us-east-1a = "10.32.16.0/20",
    us-east-1b ="10.32.32.0/20",
    us-east-1c ="10.32.64.0/20",
    us-east-1d = "10.32.128.0/20"
}
}

resource "aws_subnet" "public-aws_subnet" {
  for_each = local.public-cidr_block
  vpc_id = aws_vpc.cluster-vpc.id
  cidr_block = each.value
  availability_zone = each.key
  map_public_ip_on_launch = true
  enable_resource_name_dns_a_record_on_launch = true
}

// IAM role for cluster 


output "vpc" {
  value = aws_vpc.cluster-vpc
}
output "subnet" {
  value = aws_subnet.public-aws_subnet
}