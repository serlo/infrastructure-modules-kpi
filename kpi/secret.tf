resource "kubernetes_secret" "kpi_secret" {
  metadata {
    name      = "kpi-secret"
    namespace = var.namespace
  }

  data = {
    "datasources.yaml" = templatefile(
      "${path.module}/datasources.yaml.tpl",
      {
        athene2_database_host     = var.athene2_database_host
        athene2_database_username = var.athene2_database_username_readonly
        athene2_database_password = var.athene2_database_password_readonly
        kpi_database_host         = var.kpi_database_host
        kpi_database_username     = var.kpi_database_username_readonly
        kpi_database_password     = var.kpi_database_password_readonly
        kpi_database_name         = var.kpi_database_name
      }
    )
    "athene-database-password-readonly" = var.athene2_database_password_readonly
    "kpi-database-password-default"     = var.kpi_database_password_default
    "config.yaml" = templatefile(
      "${path.module}/mysql-importer-config.yaml.tpl",
      {
        mysql_importer_interval_in_min = var.mysql_importer_interval_in_min
        mysql_importer_log_level       = var.mysql_importer_log_level
        athene2_db_host                = var.athene2_database_host
        athene2_db_user                = var.athene2_database_username_readonly
        athene2_db_password            = var.athene2_database_password_readonly
        athene2_db_name                = var.athene2_database_name
        kpi_database_host              = var.kpi_database_host
        kpi_database_port              = 5432
        kpi_database_name              = var.kpi_database_name
        kpi_database_username          = var.kpi_database_username_default
        kpi_database_password          = var.kpi_database_password_default
      }
    )
  }

  type = "Opaque"
}
