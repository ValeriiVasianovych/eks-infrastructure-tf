output "cluster_name" {
  value       = aws_eks_cluster.eks.name
  description = "The name of the EKS cluster"
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.eks.endpoint
  description = "The endpoint for the EKS cluster API server"
}

output "cluster_ca_certificate" {
  value       = aws_eks_cluster.eks.certificate_authority[0].data
  description = "The base64 encoded certificate data required to communicate with the cluster"
}

output "eks_oidc_issuer" {
  value       = aws_eks_cluster.eks.identity[0].oidc[0].issuer
  description = "The OIDC issuer URL for the EKS cluster"
}

output "cluster_security_group_id" {
  value       = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
  description = "The security group ID attached to the EKS cluster"
}

output "cluster_iam_role_name" {
  value       = aws_iam_role.eks.name
  description = "The IAM role name of the EKS cluster"
}

output "cluster_iam_role_arn" {
  value       = aws_iam_role.eks.arn
  description = "The IAM role ARN of the EKS cluster"
}

output "node_group_name" {
  value       = aws_eks_node_group.nodes.node_group_name
  description = "The name of the EKS node group"
}

output "node_group_iam_role_name" {
  value       = aws_iam_role.nodes.name
  description = "The IAM role name of the EKS node group"
}

output "node_group_iam_role_arn" {
  value       = aws_iam_role.nodes.arn
  description = "The IAM role ARN of the EKS node group"
}

output "node_group_status" {
  value       = aws_eks_node_group.nodes.status
  description = "The status of the EKS node group"
}

output "node_group_ami_type" {
  value       = aws_eks_node_group.nodes.ami_type
  description = "The AMI type of the EKS node group"
}

output "node_group_disk_size" {
  value       = aws_eks_node_group.nodes.disk_size
  description = "The disk size of the EKS node group instances"
}

output "node_group_instance_types" {
  value       = aws_eks_node_group.nodes.instance_types
  description = "The instance types of the EKS node group"
}
