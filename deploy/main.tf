variable "host" { default = "https://40258DB952129BC2E79FCFFE57FE9E7F.gr7.eu-west-1.eks.amazonaws.com" }
variable "cluster_ca_certificate" { default = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN5RENDQWJDZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJd01USXhOVEUxTURneU1Wb1hEVE13TVRJeE16RTFNRGd5TVZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTVhhCndQclZqbTRSaVRZZ3ZqTTRQSkpucXpiRFNOYlJoaVZKcjdPdGRiWkpoNGFCNWxMZjFLbzM4dDFrM3NlUkt4WUcKMjFkODJ2RlhSL1c4VEtrUlJ5RmJ0S25DNWRjd0h3bWE3MVZoSmZhbVZSWlhUdEZtMmd3RkQ0dlJtUmFhTlp5TgorcTROcmxyRWZ2ZWJIMjdUM0FaT1BVODFvNUc0VmNsSmhQanhOZ3R4bHVxY1ZuSyswWU5IeXVVbCs3UFg2cjZDCmNLTjFvYzdHb2NaV0tsWmhRV3hwU09mN1VvYndhTy9TS0UwSnFoY0luVkw0WjNBeGJvV2VRN2x3Y281SjZpUUMKem8rRi9wZGdKaGxoTkFNQUViU2FBT0tnVnpwNGEwb2hZWCt0QjdtYldsZUJkZkRzaGhBK0RBN3U1cThIcXVUeApPUi9mWFNnTE9lNVRRZjBEMWhrQ0F3RUFBYU1qTUNFd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFGL0wyTEt2ZG96SmY5bWVJcDgrbURldldZcngKZE96dVdpdTJ0S0R1N0hJKytNSC96WDdKTGZzUTNEQVJzK0g0cGt1MjY0UjYrWHNHcVpuU3d6WEVPQTI3MEdOawpBajJHS1AwMEtlUGRiNlVGMmkyVm1DNzl4NnJ6YkJxcGlwTjdoSnNZNEE5NlhaYTkrZkIxdHoxaEIzUmdGTHVpCmppanRFQXBaanlvNC9ibGFzeVUxK1dld3FRdUQ3Y2VuREhCempla2h3NUpLYndrendCZ2NONzhONVBjUmxVNXIKVVJSQnNISno3WU9CZmd5UFNac0RGYXk3YzRMOFArci9qUnU0SmxZcEFpamY5U0NPNjgrbEdDOTRSNzlIdEU4WQpwaUErMDR5amNDQUNCNDRpWmhWSDd3S2ROVkxoOHU3QS85WEtSeWRkaFdGS0tqK1FtY3U4UjRPQjF3bz0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=" }
variable "token" { default = "k8s-aws-v1.aHR0cHM6Ly9zdHMuYW1hem9uYXdzLmNvbS8_QWN0aW9uPUdldENhbGxlcklkZW50aXR5JlZlcnNpb249MjAxMS0wNi0xNSZYLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFKQUNPVDU3TlJMSlJMS0pBJTJGMjAyMDEyMTUlMkZ1cy1lYXN0LTElMkZzdHMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDIwMTIxNVQxNTEzMjZaJlgtQW16LUV4cGlyZXM9MCZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QlM0J4LWs4cy1hd3MtaWQmWC1BbXotU2lnbmF0dXJlPThjZWY0NDE3MzY0ODA3OWE0NmRlMjEyNDRlOTY3ZDQ1YTY0Zjg4MzU0NDlmMTBiYjZlNjU0NzMyNTMwODI4NGI"}

provider "kubernetes" {
  host                   = var.host
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
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
