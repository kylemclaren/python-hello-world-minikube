variable "host" { default = "https://1290F4F61C86FAD899C61F1E23A900A2.gr7.eu-west-1.eks.amazonaws.com" }
variable "cluster_ca_certificate" { default = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN5RENDQWJDZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJd01USXhOVEV5TlRReE1Wb1hEVE13TVRJeE16RXlOVFF4TVZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTGtLCm5BMHVRWXRGQmpQM3BOODRaTmRINUp6VzdHdFU5WTM2aGNUSjdaT3NiRG9samJCaC9EdEViZHR0TzZZMVozTHYKZUkrc2lQekJRSEpMdkNqUmtZSFJ1ejQ4OWpQRE5IcEdvcDJocExydHdBMXp4S3ZUZ2FUY0kwbVhJM3lFSlpkeQp1STIwSHVRSk1mYzlLU3Q2TStXbm5QaHNJZmN1eCtsNWJwa3B4QXhZc0xnZGc4eG9HUTgrbVpZaEVPSDUxajk5CkUyNHFRTlpQTzQ3aCtQOHQxdnJRRW10Q3FwdHRTZ2QweDFoVnZySmV4NFE2elF3dFI1WjRBQ0dxak9DcGFWWVYKY1ZsNW1oTENZOGJYZGdqRzI1a1QvZ2hVM3hST0VmSm1qdGVnZmJJdTkzVGxxOXhBbkNTT1F4S0FKTEVESmROTQplZXpsMEg5VldUU2c0V2RQSGJzQ0F3RUFBYU1qTUNFd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFHUFBSOWtjSGVhR1lLV1VONTRFV2cwRVBldEoKUGRhaDV1dFc0UnR6ZVZaSDl6d3ZvWVhxNlh4amhHZVZDRXpPYmpUd2JwaFBMYnBOeEswKzAvZ1gyeFRGWmlvOApiSXF6WWhqMFowcW9UcFpPMjFDRWpyOXI1S0hxVTVTdFFxZkpGdXhtNEdHRVh4b3U5dTNxRjQySGIzS3QxTzMrCmtDVExxTjFvQ29nRkdUeHgyVUhDM3plckYyejQzNmducU1CTXVacDZjYUJYSVlPSEo3RDZFak9PYldmQnhkYnYKS0VzemkxL1lJSkNFT1dNKzAwR1lJRlVyLzZpNXdoSDJUR3l5ajdtcUdHcFNhWlRzWG5VbHhST09BVDNXSGRqdwpuVmx0eGc2U1IxLzdKdjh2YzRVYURQbG5HWXdENGVDeTV4ZzEySkNYVWloSmVJNkE4aTEvNkJlT0tsdz0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=" }
variable "token" { default = "k8s-aws-v1.aHR0cHM6Ly9zdHMuYW1hem9uYXdzLmNvbS8_QWN0aW9uPUdldENhbGxlcklkZW50aXR5JlZlcnNpb249MjAxMS0wNi0xNSZYLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFKQUNPVDU3TlJMSlJMS0pBJTJGMjAyMDEyMTUlMkZ1cy1lYXN0LTElMkZzdHMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDIwMTIxNVQxMzEzMjRaJlgtQW16LUV4cGlyZXM9MCZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QlM0J4LWs4cy1hd3MtaWQmWC1BbXotU2lnbmF0dXJlPTRmZjc3MTc1NjQ5MGU3NWZlMmRhYjY1N2FkNzBlZmZhN2QzMTRmOWMxYjdjYjIwMDFiODhkMmFhMmY3OTQ0ZDI"}

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
