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

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = ""
}

variable "cluster_iam_arn" {
  description = "The IAM role ARN of the EKS cluster"
  type        = string
  default     = ""
}

variable "kube_prometheus_stack_version" {
  description = "Version of the kube-prometheus-stack Helm chart"
  type        = string
  default     = ""
}

variable "hosted_zone" {
  description = "The hosted zone name"
  type        = string
  default     = ""
}