output "grafana_ingress_host" {
  value       = "grafana.${var.env}.${var.hosted_zone_name}"
  description = "The hostname for Grafana ingress"

  depends_on = [kubernetes_ingress_v1.grafana]
}

output "prometheus_ingress_host" {
  value       = "prometheus.${var.env}.${var.hosted_zone_name}"
  description = "The hostname for Prometheus ingress"

  depends_on = [kubernetes_ingress_v1.prometheus]
}

