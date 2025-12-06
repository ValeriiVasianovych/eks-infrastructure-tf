output "grafana_ingress_host" {
  value       = "grafana.${var.hosted_zone_name}"
  description = "The hostname for Grafana ingress"
}

output "prometheus_ingress_host" {
  value       = "prometheus.${var.hosted_zone_name}"
  description = "The hostname for Prometheus ingress"
}

