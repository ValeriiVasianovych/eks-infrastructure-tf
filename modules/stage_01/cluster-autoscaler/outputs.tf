output "cluster_autoscaler_iam_role_arn" {
  value       = aws_iam_role.cluster_autoscaler.arn
  description = "The IAM role ARN for the cluster autoscaler"
}

