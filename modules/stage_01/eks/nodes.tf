resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.eks.name
  version         = var.cluster_version
  node_group_name = "${var.prefix_name}-node-group-${var.env}"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = var.max_unavailable
  }

  labels = {
    role = "${var.prefix_name}-node-group-${var.env}"
  }

  capacity_type  = var.capacity_type
  instance_types = [var.instance_types]

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
    aws_iam_role_policy_attachment.amazon_ssm_managed_instance_core,
    aws_iam_role_policy_attachment.amazon_eks_service_policy
  ]

  # For Pod Identity support
  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }
}
