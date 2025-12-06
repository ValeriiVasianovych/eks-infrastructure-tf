output "ebs_csi_driver_iam_role_arn" {
  value       = aws_iam_role.ebs_csi_driver.arn
  description = "The IAM role ARN for the EBS CSI driver"
}

