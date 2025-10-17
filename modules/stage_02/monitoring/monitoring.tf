resource "helm_release" "kube-prometheus-stack" {
  name = "kube-prometheus-stack"

  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true
  version          = "75.15.0"

  values = [file("${path.module}/conf/values.yaml")]
}

