# main.tf (Updated with Route Tables and Subnet Associations)

provider "aws" {
  region = var.region
}

# Define a VPC
resource "aws_vpc" "commerce-app_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

# Define subnets (public and private)
resource "aws_subnet" "public_subnet" {
  count                   = length(var.zone_alphabet)
  vpc_id                  = aws_vpc.commerce-app_vpc.id
  cidr_block              = var.public_subnet_cidr_blocks
  availability_zone       = "${var.region}${element(var.zone_alphabet, count.index)}"
  map_public_ip_on_launch = true # Enable public IPs
  tags = {
    Name = "${var.env_prefix}-public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.zone_alphabet)
  vpc_id            = aws_vpc.commerce-app_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks
  availability_zone = "${var.region}${element(var.zone_alphabet, count.index)}"
  tags = {
    Name = "${var.env_prefix}-private-subnet"
  }
}
resource "aws_internet_gateway" "commerce-app_igw" {
  vpc_id = aws_vpc.commerce-app_vpc.id
  tags = {
    Name = "${var.env_prefix}-public-rt-igw"
  }
}

# Define Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.commerce-app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.commerce-app_igw.id
  }
  tags = {
    Name = "${var.env_prefix}-public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.commerce-app_vpc.id
  tags = {
    Name = "${var.env_prefix}-private-rt"
  }
}

# Associate Subnets with Route Tables
resource "aws_route_table_association" "public_subnet" {
  count          = length(var.zone_alphabet)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_subnet" {
  count          = length(var.zone_alphabet)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

# Define EKS Cluster
/*resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids         = aws_subnet.private_subnet[*].id
    security_group_ids = var.eks_security_group_ids
  }
}

# Define EKS Node Group
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.eks_node_group_name
  node_role_arn   = var.eks_node_role_arn

  scaling_config {
    desired_size = var.eks_desired_size
    max_size     = var.eks_max_size
    min_size     = var.eks_min_size
  }

  launch_template {
    version = var.launch_template_version

    launch_template_specification {
      launch_template_id = var.launch_template_id
      version            = var.launch_template_version
    }
  }

  remote_access {
    ec2_ssh_key = var.ssh_key_name
  }

  vpc_config {
    subnet_ids = aws_subnet.private_subnet[*].id
  }
}

# Define an EC2 instance for Jenkins
resource "aws_instance" "jenkins_server" {
  ami           = var.jenkins_ami_id
  instance_type = var.jenkins_instance_type

  subnet_id              = element(aws_subnet.public_subnet[*].id, 0) # Place Jenkins in the public subnet
  vpc_security_group_ids = var.jenkins_security_group_ids

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              EOF
}
*/

# Define an S3 bucket
resource "aws_s3_bucket" "commerce-app_bucket" {
  bucket = var.bucket_name
  tags = {
    Name = "${var.env_prefix}-${var.bucket_name}"
  }
}

