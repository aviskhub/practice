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
    ap-south-1a = "10.32.16.0/20",
    ap-south-1b ="10.32.32.0/20",
    ap-south-1c ="10.32.64.0/20"
}
}

resource "aws_subnet" "public-aws_subnet" {
  for_each = local.public-cidr_block
  vpc_id = aws_vpc.cluster-vpc.id
  cidr_block = each.value
  availability_zone = each.key
  map_public_ip_on_launch = true
  enable_resource_name_dns_a_record_on_launch = true
  tags = {
    Name = "Public-subnet-${each.key}"
  }
}

# // IAM role for cluster 
# resource "aws_iam_role" "cluster-role" {
#   name = "eks-cluster-example"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "sts:AssumeRole",
#           "sts:TagSession"
#         ]
#         Effect = "Allow"
#         Principal = {
#           Service = "eks.amazonaws.com"
#         }
#       },
#     ]
#   })
# }
# resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.cluster-role.name
# }

# resource "aws_security_group" "eks-sg" {
#   vpc_id = aws_vpc.cluster-vpc.id
# }
# resource "aws_eks_cluster" "cluster" {
#   name = "eks-cluster"
#   role_arn = aws_iam_role.cluster-role.arn
#   vpc_config {
#     subnet_ids = [for key, value in aws_subnet.public-aws_subnet : value.id ]
#     security_group_ids = [aws_security_group.eks-sg.id]
#   }
#   depends_on = [ aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy ]
# }
# // iam role for worker node 

# resource "aws_iam_role" "example" {
#   name = "eks-node-group-example"

#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#     Version = "2012-10-17"
#   })
# }

# resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.example.name
# }

# resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.example.name
# }

# resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.example.name
# }

# resource "aws_eks_node_group" "node-group" {
#   node_group_name = "eks-node-group"
#   cluster_name = aws_eks_cluster.cluster.name
#   node_role_arn = aws_iam_role.example.arn
#   subnet_ids = [ for key, value in aws_subnet.public-aws_subnet : value.id ]
#   scaling_config {
#     max_size = 3
#     desired_size = 2
#     min_size = 1
#   }
#   instance_types = ["t2.micro"]
#   depends_on = [ aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly , 
#                 aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy ,
#                 aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy]

# }



output "vpc" {
  value = aws_vpc.cluster-vpc
}
output "subnet" {
  value = aws_subnet.public-aws_subnet
}
# output "eks-cluster" {
#   value = aws_eks_cluster.cluster
# }
# output "node-group" {
#   value = aws_eks_node_group.node-group
# }

