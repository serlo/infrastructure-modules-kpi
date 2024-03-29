resource "kubernetes_deployment" "mysql-importer-cronjob" {
  metadata {
    name      = "mysql-importer-cronjob"
    namespace = var.namespace

    labels = {
      app = "importer"
    }
  }

  spec {
    replicas = "1"

    selector {
      match_labels = {
        app = "mysql-importer"
      }
    }

    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        labels = {
          app  = "mysql-importer"
          name = "mysql-importer"
        }
      }

      spec {
        node_selector = {
          "cloud.google.com/gke-nodepool" = var.node_pool
        }

        container {
          image             = var.mysql_importer_image
          name              = "mysql-importer-container"
          image_pull_policy = var.image_pull_policy

          env {
            name  = "CRON_PATTERN"
            value = "0 5 * * *"
          }
          resources {
            limits = {
              cpu    = "50m"
              memory = "64M"
            }
            requests = {
              cpu    = "25m"
              memory = "32M"
            }
          }

          volume_mount {
            mount_path = "/tmp/config.yaml"
            sub_path   = "config.yaml"
            name       = "mysql-importer-config"
          }
        }

        volume {
          name = "mysql-importer-config"

          secret {
            secret_name = kubernetes_secret.kpi_secret.metadata.0.name

            items {
              key  = "config.yaml"
              path = "config.yaml"
              mode = "0444"
            }
          }
        }
      }
    }
  }
}
