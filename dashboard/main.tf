locals {
  name      = "dashboard"
  namespace = "api"
}

variable "node_pool" {
  type = string
}

variable "image_tag" {
  type        = string
  description = "See https://github.com/serlo/evaluations/kpi_app"
}

variable "mysql_database" {
  type = object({
    host     = string
    password = string
  })
  sensitive = true
}

variable "postgres_database" {
  type = object({
    host     = string
    password = string
  })
  sensitive = true
}

output "dashboard_service_name" {
  value = kubernetes_service.dashboard_service.metadata[0].name
}

output "dashboard_service_port" {
  value = kubernetes_service.dashboard_service.spec[0].port[0].port
}

resource "kubernetes_deployment" "dashboard" {
  metadata {
    name      = local.name
    namespace = local.namespace

    labels = {
      app = local.name
    }
  }

  spec {
    replicas = "1"

    selector {
      match_labels = {
        app = local.name
      }
    }

    template {
      metadata {
        labels = {
          app  = local.name
          name = local.name
        }
      }

      spec {
        node_selector = {
          "cloud.google.com/gke-nodepool" = var.node_pool
        }

        container {
          image = "eu.gcr.io/serlo-shared/kpi-dashboard:${var.image_tag}"
          name  = local.name
          env {
            name  = "MYSQL_HOST"
            value = var.mysql_database.host
          }
          env {
            name  = "MYSQL_PASSWORD"
            value = var.mysql_database.password
          }
          env {
            name  = "MYSQL_USER"
            value = "serlo_readonly"
          }
          env {
            name  = "POSTGRES_HOST"
            value = var.postgres_database.host
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = var.postgres_database.password
          }
          env {
            name  = "POSTGRES_USER"
            value = "serlo_readonly"
          }
          port {
            name           = "http"
            container_port = 8050
            protocol       = "TCP"
          }
          resources {
            limits = {
              cpu    = "200m"
              memory = "300M"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "dashboard_service" {
  metadata {
    name      = "dashboard"
    namespace = local.namespace
  }

  spec {
    selector = {
      app = local.name
    }

    port {
      port        = 8050
      target_port = 8050
    }

    type = "ClusterIP"
  }
}
