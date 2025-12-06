output "lb_controller_iam_role_arn" {
  value       = aws_iam_role.lbc_controller.arn
  description = "The IAM role ARN for the AWS Load Balancer Controller"
}

