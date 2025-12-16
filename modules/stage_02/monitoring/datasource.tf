data "aws_route53_zone" "main" {
  name         = var.hosted_zone_name
  private_zone = false
}

resource "time_sleep" "wait_for_alb" {
  depends_on = [kubernetes_ingress_v1.grafana, kubernetes_ingress_v1.prometheus]

  create_duration = "30s"
}

data "aws_lb" "shared_alb" {
  depends_on = [time_sleep.wait_for_alb]

  tags = {
    "account_id"               = var.account_id
    "environment"              = var.env
    "ingress.k8s.aws/resource" = "LoadBalancer"
  }
}
