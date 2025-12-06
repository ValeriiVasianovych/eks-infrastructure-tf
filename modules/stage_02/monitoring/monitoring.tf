resource "helm_release" "kube-prometheus-stack" {
  depends_on = [kubernetes_namespace.monitoring]

  name = "kube-prometheus-stack"

  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  create_namespace = false
  version          = "75.15.0"

  values = [file("${path.module}/conf/values.yaml")]
}

