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

variable "vpc_id" {
  description = "The VPC ID where the Load Balancer Controller will be deployed"
  type        = string
  default     = ""
}

variable "lb_controller_version" {
  description = "Version of Load Balancer Controller"
  type        = string
  default     = ""
}

variable "nginx_ingress_version" {
  description = "Version of NGINX Ingress Controller"
  type        = string
  default     = ""
}

variable "cert_manager_version" {
  description = "Version of Cert-Manager"
  type        = string
  default     = ""
}