variable "region" {
  description = "The AWS region"
  type        = string
  default     = ""
}

variable "env" {
  description = "The environment"
  type        = string
  default     = ""
}

variable "prefix_name" {
  description = "The name prefix of the EKS cluster"
  type        = string
  default     = ""
}

variable "automation_role_arn" {
  description = "The ARN of the automation role for EKS access entry"
  type        = string
  default     = ""
}

variable "automation_access_policy_arn" {
  description = "The ARN of the access policy for automation role"
  type        = string
  default     = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}

variable "account_id" {
  description = "The AWS account ID"
  type        = string
  default     = ""
}

variable "cluster_version" {
  description = "The Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.32"
}

variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be deployed"
  type        = string
  default     = ""
}

variable "public_subnet_ids" {
  description = "The public subnet IDs for the EKS cluster"
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "The private subnet IDs for the EKS cluster"
  type        = list(string)
  default     = []
}

variable "desired_size" {
  description = "The desired number of worker nodes"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "The minimum number of worker nodes"
  type        = number
  default     = 2
}

variable "max_unavailable" {
  description = "The maximum number of worker nodes that can be unavailable during an update"
  type        = number
  default     = 1
}

variable "capacity_type" {
  description = "The capacity type for the worker nodes (e.g., ON_DEMAND, SPOT)"
  type        = string
  default     = ""
}

variable "instance_types" {
  description = "The instance types to use for the worker nodes"
  type        = string
  default     = ""
}

variable "ingress_ports" {
  description = "The ports to allow ingress traffic to the EKS cluster"
  type        = list(number)
  default     = []
}

# Addon versions
variable "coredns_version" {
  description = "Version of CoreDNS addon"
  type        = string
  default     = ""
}

variable "kube_proxy_version" {
  description = "Version of kube-proxy addon"
  type        = string
  default     = ""
}

variable "vpc_cni_version" {
  description = "Version of VPC CNI addon"
  type        = string
  default     = ""
}

variable "pod_identity_version" {
  description = "Version of EKS Pod Identity addon"
  type        = string
  default     = ""
}

# variable "cluster_autoscaler_version" {
#   description = "Version of Cluster Autoscaler addon"
#   type        = string
#   default     = ""
# }

variable "metrics_server_version" {
  description = "Version of Metrics Server addon"
  type        = string
  default     = ""
}
