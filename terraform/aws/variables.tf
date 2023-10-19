variable "region" {
  description = "AWS region for the resources"
  type        = string
  default     = "us-east-1"
}

variable "env_prefix" {
    description = "Development environment like dev, prod or staging"
    type = string
    default = "dev"
}

variable "zone_alphabet" {
  description = "AWS availability zone letters"
  type        = list(string)
  default     = ["a", "b",] # Add more letters if needed
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

/*variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "commerce-eks-cluster"
}

variable "eks_cluster_role_arn" {
  description = "ARN of the IAM role for EKS cluster"
  type        = string
}

variable "eks_node_group_name" {
  description = "Name of the EKS node group"
  type        = string
  default     = "example-node-group"
}

variable "eks_node_role_arn" {
  description = "ARN of the IAM role for EKS nodes"
  type        = string
}

variable "eks_desired_size" {
  description = "Desired number of nodes in the EKS node group"
  type        = number
  default     = 3
}

variable "eks_max_size" {
  description = "Maximum number of nodes in the EKS node group"
  type        = number
  default     = 3
}

variable "eks_min_size" {
  description = "Minimum number of nodes in the EKS node group"
  type        = number
  default     = 3
}

variable "jenkins_ami_id" {
  description = "AMI ID for the Jenkins server"
  type        = string
}

variable "jenkins_instance_type" {
  description = "Instance type for the Jenkins server"
  type        = string
  default     = "t2.micro"
}

variable "jenkins_subnet_id" {
  description = "Subnet ID for the Jenkins server"
  type        = string
}

variable "jenkins_security_group_ids" {
  description = "Security group IDs for the Jenkins server"
  type        = list(string)
}

variable "ssh_key_name" {
  description = "SSH key name for the Jenkins server"
  type        = string
}

variable "launch_template_id" {
  description = "ID of the launch template for the EKS node group"
  type        = string
}

variable "launch_template_version" {
  description = "Version of the launch template for the EKS node group"
  type        = string
  default     = "$Latest"
}
*/
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default = "commerce-app"
}

