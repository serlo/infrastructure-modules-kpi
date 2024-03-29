resource "kubernetes_deployment" "grafana_deployment" {
  metadata {
    name      = "grafana-app"
    namespace = var.namespace

    labels = {
      app = "grafana"
    }
  }

  spec {
    replicas = "1"

    selector {
      match_labels = {
        app = "grafana"
      }
    }

    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        labels = {
          app  = "grafana"
          name = "grafana"
        }
      }

      spec {
        node_selector = {
          "cloud.google.com/gke-nodepool" = var.node_pool
        }

        dns_policy = "ClusterFirstWithHostNet"

        container {
          image = var.grafana_image
          name  = "grafana"

          image_pull_policy = var.image_pull_policy

          resources {
            limits = {
              cpu    = "100m"
              memory = "256M"
            }
            requests = {
              cpu    = "100m"
              memory = "128M"
            }
          }

          port {
            name           = "http"
            container_port = 3000
            protocol       = "TCP"
          }

          env {
            name  = "GF_SECURITY_ADMIN_PASSWORD"
            value = var.grafana_admin_password
          }

          env {
            name  = "GF_SECURITY_SERLO_PASSWORD"
            value = var.grafana_serlo_password
          }

          #grafana-clock-panel,
          env {
            name  = "GF_INSTALL_PLUGINS"
            value = "grafana-clock-panel,grafana-simple-json-datasource,grafana-piechart-panel"
          }

          env {
            name  = "GF_PATH_PROVISIONING"
            value = "/etc/grafana/provisioning"
          }

          env {
            name  = "GF_SERVER_ROOT_URL"
            value = "https://stats.${var.domain}/"
          }

          volume_mount {
            name       = "grafana-config-datasources"
            mount_path = "/etc/grafana/provisioning/datasources/"
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 3000
            }

            initial_delay_seconds = 5
            period_seconds        = 30
          }
        }

        volume {
          name = "grafana-config-datasources"

          secret {
            secret_name = kubernetes_secret.kpi_secret.metadata.0.name

            items {
              key  = "datasources.yaml"
              path = "datasources.yaml"
            }
          }
        }

        # See http://docs.grafana.org/installation/docker/#user-id-changes
        security_context {
          fs_group = "472"
        }
      }
    }
  }
}

# Service/Loadbalancer
resource "kubernetes_service" "grafana_service" {
  metadata {
    name      = "grafana-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "grafana"
    }

    port {
      name        = "http"
      port        = 80
      protocol    = "TCP"
      target_port = 3000
    }

    type = "ClusterIP"
  }
}
