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

variable "pod_identity_version" {
  description = "Version of Pod Identity addon"
  type        = string
  default     = ""
}

variable "cluster_name" {
    description = "The name of the EKS cluster"
    type        = string
    default     = ""
}

variable "vpc_id" {
    description = "The ID of the VPC"
    type        = string
    default     = ""
}