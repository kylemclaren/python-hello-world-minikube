data "aws_eks_cluster" "cluster" {
  name = module.my-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.my-cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

module "my-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "equalexperts"
  cluster_version = "1.18"
  subnets         = ["subnet-0e58d4057d811c830", "subnet-0cc57d5a6b6e546b1", "subnet-04ba8e31e6d2788dc"]
  vpc_id          = "	vpc-05af4d83f47455708"

  worker_groups = [
    {
      instance_type = "t2.micro"
      asg_max_size  = 2
    }
  ]
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
          image = "kylemclaren/hello-world:1.0.0"
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
