# Pod indentity
resource "aws_eks_addon" "eks_pod_identity" {
  cluster_name  = aws_eks_cluster.eks.name
  addon_name    = "eks-pod-identity-agent"
  addon_version = var.pod_identity_version

  depends_on = [aws_eks_node_group.nodes]
}

# CoreDNS
resource "aws_eks_addon" "coredns" {
  cluster_name  = aws_eks_cluster.eks.name
  addon_name    = "coredns"
  addon_version = var.coredns_version

  depends_on = [aws_eks_node_group.nodes]
}

# Kube Proxy
resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = aws_eks_cluster.eks.name
  addon_name    = "kube-proxy"
  addon_version = var.kube_proxy_version

  depends_on = [aws_eks_node_group.nodes]
}

# VPC CNI
resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.eks.name
  addon_name    = "vpc-cni"
  addon_version = var.vpc_cni_version

  depends_on = [aws_eks_node_group.nodes]
}

# Metrics Server
resource "aws_eks_addon" "metrics_server" {
  cluster_name  = aws_eks_cluster.eks.name
  addon_name    = "metrics-server"
  addon_version = var.metrics_server_version

  depends_on = [aws_eks_node_group.nodes]
}