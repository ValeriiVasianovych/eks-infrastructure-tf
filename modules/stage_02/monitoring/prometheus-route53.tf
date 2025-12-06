resource "aws_acm_certificate" "prometheus_domain_cert" {
  domain_name       = "prometheus.${data.aws_route53_zone.main.name}"
  validation_method = "DNS"

  tags = {
    Name = "${var.env}-prometheus-certificate"
  }
}

resource "aws_route53_record" "prometheus_domain_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.prometheus_domain_cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main.id
}

resource "aws_acm_certificate_validation" "prometheus_domain_cert_validation" {
  depends_on = [aws_route53_record.prometheus_domain_cert_validation]

  certificate_arn         = aws_acm_certificate.prometheus_domain_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.prometheus_domain_cert_validation : record.fqdn]
}

resource "aws_route53_record" "prometheus_domain_record" {
  depends_on = [kubernetes_ingress_v1.prometheus, data.aws_lb.shared_alb]

  zone_id = data.aws_route53_zone.main.id
  name    = "prometheus.${var.hosted_zone_name}"
  type    = "A"

  alias {
    name                   = data.aws_lb.shared_alb.dns_name
    zone_id                = data.aws_lb.shared_alb.zone_id
    evaluate_target_health = true
  }
}
