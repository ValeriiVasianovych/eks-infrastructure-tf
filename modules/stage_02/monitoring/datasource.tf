data "aws_route53_zone" "main" {
  name         = var.hosted_zone_name
  private_zone = false
}

data "aws_lb" "shared_alb" {
  depends_on = [kubernetes_ingress_v1.grafana, kubernetes_ingress_v1.prometheus]

  tags = {
    "account_id"               = var.account_id
    "environment"              = var.env
    "ingress.k8s.aws/resource" = "LoadBalancer"
  }
}
