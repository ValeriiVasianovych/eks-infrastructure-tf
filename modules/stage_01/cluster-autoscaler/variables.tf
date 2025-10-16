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

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = ""
}

variable "cluster_autoscaler_version" {
  description = "Version of Cluster Autoscaler"
  type        = string
  default     = ""
}