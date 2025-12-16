resource "helm_release" "kube-prometheus-stack" {
  depends_on = [kubernetes_namespace_v1.monitoring]

  name = "kube-prometheus-stack"

  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = kubernetes_namespace_v1.monitoring.metadata[0].name
  create_namespace = false
  version          = var.kube_prometheus_stack_version

  values = [file("${path.module}/conf/values.yaml")]
}

