output "grafana_ingress_host" {
  value       = "${var.env}.grafana.${var.hosted_zone_name}"
  description = "The hostname for Grafana ingress"

  depends_on = [kubernetes_ingress_v1.grafana]
}

output "prometheus_ingress_host" {
  value       = "${var.env}.prometheus.${var.hosted_zone_name}"
  description = "The hostname for Prometheus ingress"

  depends_on = [kubernetes_ingress_v1.prometheus]
}

