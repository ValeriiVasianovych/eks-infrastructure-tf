resource "kubernetes_ingress_v1" "prometheus" {
  depends_on = [kubernetes_namespace.monitoring, helm_release.kube-prometheus-stack]

  metadata {
    name      = "kube-prometheus-stack-prometheus"
    namespace = kubernetes_namespace.monitoring.metadata[0].name

    annotations = {
      "alb.ingress.kubernetes.io/backend-protocol"     = "HTTP"
      "alb.ingress.kubernetes.io/group.name"           = "common-services"
      "alb.ingress.kubernetes.io/healthcheck-path"     = "/-/healthy"
      "alb.ingress.kubernetes.io/healthcheck-port"     = "traffic-port"
      "alb.ingress.kubernetes.io/healthcheck-protocol" = "HTTP"
      "alb.ingress.kubernetes.io/listen-ports"         = "[{\"HTTPS\": 443}]"
      "alb.ingress.kubernetes.io/scheme"               = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"          = "ip"
      "alb.ingress.kubernetes.io/tags"                 = "account_id=${var.account_id},environment=${var.env}"
      "kubernetes.io/ingress.class"                    = "alb"
    }
  }

  spec {
    rule {
      host = "${var.env}.prometheus.${var.hosted_zone_name}"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "kube-prometheus-stack-prometheus"
              port {
                number = 9090
              }
            }
          }
        }
      }
    }
  }
}
