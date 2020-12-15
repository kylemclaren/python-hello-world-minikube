variable "host" { }
variable "cluster_ca_certificate" { }
variable "token" { }

provider "kubernetes" {
  host                   = var.host
  cluster_ca_certificate = var.cluster_ca_certificate
  token                  = var.token
  load_config_file       = false
  version                = "~> 1.9"
}

resource "kubernetes_namespace" "k8s-apps-namespace" {
  metadata {
    name = "apps"
  }
}

resource "kubernetes_deployment" "hello-world" {
  metadata {
    name      = "hello-world"
    namespace = "apps"
    labels = {
      App = "helloWorldApp"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "helloWorldApp"
      }
    }
    template {
      metadata {
        labels = {
          App = "helloWorldApp"
        }
      }
      spec {
        container {
          image = "hello-world:1.0.0"
          name  = "hello-world-app"

          port {
            container_port = 8080
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "hello-world" {
  metadata {
    name      = "hello-world"
    namespace = "apps"
  }
  spec {
    selector = {
      App = kubernetes_deployment.hello-world.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 8080
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}

output "lb_ip" {
  value = kubernetes_service.hello-world.load_balancer_ingress[0].ip
}
