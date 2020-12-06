provider "kubernetes" {
  config_context_cluster = "minikube"
}

resource "kubernetes_namespace" "k8s-apps-namespace" {
  metadata {
    name = "apps"
  }
}

