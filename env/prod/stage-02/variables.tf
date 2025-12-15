variable "kube_prometheus_stack_version" {
  description = "Version of the kube-prometheus-stack Helm chart"
  type        = string
  default     = "75.15.0"
}

variable "hosted_zone_name" {
  description = "The hosted zone name"
  type        = string
  # default     = "domain.xyz"
}