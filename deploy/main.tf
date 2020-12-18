terraform {
  backend "s3" {
    bucket = "terra-backend-123"
    key    = "network/terraform.tfstate"
    region = "eu-west-1"
  }
}

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
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  node_groups = {
    first = {
      desired_capacity = 1
      max_capacity     = 1
      min_capacity     = 1
      instance_type    = "t3.medium"
    }
  }
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
          image_pull_policy = "Always"

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
        node_selector = {
          "node.kubernetes.io/instance-type" = "t3.medium"
        }
      }
    }
  }
  depends_on = [module.my-cluster]
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
