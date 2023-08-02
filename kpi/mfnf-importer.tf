resource "kubernetes_cron_job_v1" "mfnf-importer" {
  count = 1

  metadata {
    name      = "mfnf-importer"
    namespace = var.namespace

    labels = {
      app = "mfnf-importer"
    }
  }

  spec {
    concurrency_policy = "Forbid"
    schedule           = "0 0 * * *"

    job_template {
      metadata {
        labels = {
          app  = "mfnf-importer"
          name = "mfnf-importer"
        }
      }

      spec {
        backoff_limit = 2
        template {
          metadata {
            labels = {
              app  = "mfnf-importer"
              name = "mfnf-importer"
            }
          }
          spec {
            node_selector = {
              "cloud.google.com/gke-nodepool" = var.node_pool
            }

            container {
              image = var.mfnf_importer_image
              name  = "mfnf-importer"

              image_pull_policy = var.image_pull_policy

              env {
                name  = "KPI_DATABASE_HOST"
                value = var.kpi_database_host
              }
              env {
                name  = "KPI_DATABASE_PORT"
                value = "5432"
              }
              env {
                name  = "KPI_DATABASE_USER"
                value = var.kpi_database_username_default
              }
              env {
                name  = "KPI_DATABASE_NAME"
                value = var.kpi_database_name
              }
              env {
                name = "KPI_DATABASE_PASSWORD"
                value_from {
                  secret_key_ref {
                    key  = "kpi-database-password-default"
                    name = kubernetes_secret.kpi_secret.metadata.0.name
                  }
                }
              }
            }
            restart_policy = "Never"
          }
        }
      }
    }
  }
}
