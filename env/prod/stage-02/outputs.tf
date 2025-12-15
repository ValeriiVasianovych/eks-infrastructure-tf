# Monitoring Outputs
output "grafana_ingress_host" {
  value       = module.monitoring.grafana_ingress_host
  description = "The hostname for Grafana ingress"
}

output "prometheus_ingress_host" {
  value       = module.monitoring.prometheus_ingress_host
  description = "The hostname for Prometheus ingress"
}
