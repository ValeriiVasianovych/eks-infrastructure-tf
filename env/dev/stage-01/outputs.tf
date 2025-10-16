# VPC Outputs
output "vpc_region" {
  value       = module.vpc.region
  description = "The AWS region of the VPC."
}

output "vpc_env" {
  value       = module.vpc.env
  description = "The environment of the VPC."
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the VPC."
}

output "vpc_cidr_block" {
  value       = module.vpc.vpc_cidr_block
  description = "The CIDR block of the VPC."
}

output "public_subnet_cidr_blocks" {
  value       = module.vpc.public_subnet_cidr_blocks
  description = "The CIDR blocks of the public subnets."
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "The IDs of the public subnets."
}

output "private_subnet_cidr_blocks" {
  value       = module.vpc.private_subnet_cidr_blocks
  description = "The CIDR blocks of the private subnets."
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "The IDs of the private subnets."
}

# EKS Outputs
output "cluster_name" {
  value       = module.eks.cluster_name
  description = "The name of the EKS cluster"
}

output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "The endpoint for the EKS cluster API server"
}

output "eks_oidc_issuer" {
  value       = module.eks.eks_oidc_issuer
  description = "The OIDC issuer URL for the EKS cluster"
}

output "cluster_security_group_id" {
  value       = module.eks.cluster_security_group_id
  description = "The security group ID attached to the EKS cluster"
}

output "cluster_iam_role_name" {
  value       = module.eks.cluster_iam_role_name
  description = "The IAM role name of the EKS cluster"
}

output "cluster_iam_role_arn" {
  value       = module.eks.cluster_iam_role_arn
  description = "The IAM role ARN of the EKS cluster"
}

output "node_group_name" {
  value       = module.eks.node_group_name
  description = "The name of the EKS node group"
}

output "node_group_iam_role_name" {
  value       = module.eks.node_group_iam_role_name
  description = "The IAM role name of the EKS node group"
}

output "node_group_iam_role_arn" {
  value       = module.eks.node_group_iam_role_arn
  description = "The IAM role ARN of the EKS node group"
}

output "node_group_status" {
  value       = module.eks.node_group_status
  description = "The status of the EKS node group"
}

output "node_group_ami_type" {
  value       = module.eks.node_group_ami_type
  description = "The AMI type of the EKS node group"
}

output "node_group_disk_size" {
  value       = module.eks.node_group_disk_size
  description = "The disk size of the EKS node group instances"
}

output "node_group_instance_types" {
  value       = module.eks.node_group_instance_types
  description = "The instance types of the EKS node group"
}
