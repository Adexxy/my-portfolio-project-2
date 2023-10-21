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
    Name = "${var.env_prefix}-public-subnet-${element(var.zone_alphabet, count.index)}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.zone_alphabet)
  vpc_id            = aws_vpc.commerce-app_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks
  availability_zone = "${var.region}${element(var.zone_alphabet, count.index)}"
  tags = {
    Name = "${var.env_prefix}-private-subnet-${element(var.zone_alphabet, count.index)}"
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
  count = length(var.zone_alphabet)
  vpc_id = aws_vpc.commerce-app_vpc.id
  tags = {
    Name = "${var.env_prefix}-private-rt-${element(var.zone_alphabet, count.index)}"
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
  route_table_id = element(aws_route_table.private[*].id, count.index)
}

# Define Security Group

resource "aws_security_group" "jenkins_instance_sg" {
  name        = "jenkins-instance-sg"
  description = "Security group for the Jenkins instance"
  vpc_id      = aws_vpc.commerce-app_vpc.id

  # Define ingress and egress rules as needed
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.everywhere_cidr_block,] # Whitelist specific IP ranges for SSH access
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr_block,] # Whitelist specific IP ranges for web access
  }

  # Add more rules as necessary
}

resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-cluster-sg"
  description = "Security group for the EKS cluster"
  vpc_id      = aws_vpc.commerce-app_vpc.id

  # Define ingress and egress rules as needed
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["102.67.1.34/32",] # Whitelist specific IP ranges
  }

  # Add more rules as necessary
}

resource "aws_security_group_rule" "eks_cluster_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  security_group_id = aws_security_group.eks_cluster_sg.id
}


# Define EKS Cluster
resource "aws_eks_cluster" "commerce-app_cluster" {
  name     = var.eks_cluster_name
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids         = aws_subnet.public_subnet[*].id
    security_group_ids = [aws_security_group.eks_cluster_sg.id] # Note the square brackets to make it a list
  }
}

# Define EKS Node Group
resource "aws_eks_node_group" "eks_node_group" {
  count = length(var.zone_alphabet)
  cluster_name    = aws_eks_cluster.commerce-app_cluster.name
  node_group_name = var.eks_node_group_name
  node_role_arn   = var.eks_node_role_arn
  subnet_ids = [element(aws_subnet.private_subnet[*].id, count.index)]

  scaling_config {
    desired_size = var.eks_desired_size
    max_size     = var.eks_max_size
    min_size     = var.eks_min_size
  }

  remote_access {
    ec2_ssh_key = var.ssh_key_name
  }
}

# Define an EC2 instance for Jenkins
resource "aws_instance" "jenkins_server" {
  ami           = var.jenkins_ami_id
  instance_type = var.jenkins_instance_type

  subnet_id              = element(aws_subnet.public_subnet[*].id, 0) # Place Jenkins in the public subnet
  vpc_security_group_ids = [aws_security_group.jenkins_instance_sg.id] # Note the square brackets to make it a list

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              EOF
}

# Define an S3 bucket
resource "aws_s3_bucket" "commerce-app_bucket" {
  bucket = var.bucket_name
  tags = {
    Name = "${var.env_prefix}-${var.bucket_name}"
  }
}

