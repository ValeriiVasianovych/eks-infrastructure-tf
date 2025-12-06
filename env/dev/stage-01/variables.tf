variable "region" {
  description = "The AWS region"
  type        = string
  # default     = "us-east-1"
}

variable "env" {
  description = "The environment"
  type        = string
  # default     = "development"
}

variable "prefix_name" {
  description = "The name prefix of the EKS cluster"
  type        = string
  # default     = "new-eks-cluster"
}

locals {
  cluster_version = "1.33"
  desired_size    = 2
  max_size        = 10
  min_size        = 2
  max_unavailable = 1
  capacity_type   = "ON_DEMAND"
  instance_types  = "t3.small"
  ingress_ports   = [80, 443, 3000]

  # Addon versions
  coredns_version        = "v1.12.4-eksbuild.1"
  kube_proxy_version     = "v1.33.3-eksbuild.6"
  vpc_cni_version        = "v1.20.2-eksbuild.1"
  pod_identity_version   = "v1.3.8-eksbuild.2"
  ebs_csi_version        = "v1.50.1-eksbuild.1"
  metrics_server_version = "v0.8.0-eksbuild.2"

  # Charts versions
  cluster_autoscaler_version = "9.52.1"
  lb_controller_version      = "1.7.2"
  nginx_ingress_version      = "4.10.1"
  cert_manager_version       = "v1.14.5"
}
