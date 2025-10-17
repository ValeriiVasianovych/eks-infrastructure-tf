resource "helm_release" "external_nginx" {
  name = "external"

  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress"
  create_namespace = true
  version          = var.nginx_ingress_version

  values = [file("${path.module}/values/nginx-ingress.yaml")]

  depends_on = [helm_release.lbc_controller]
}

