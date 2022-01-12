#####################################################################
# variables for module kpi
#####################################################################
variable "namespace" {
  default     = "kpi"
  description = "Namespace for this module."
}

variable "node_pool" {
  type        = string
  description = "Node pool to use"
}

variable "domain" {
  description = "domain for kpi ingress"
}

variable "grafana_image" {
  default     = "eu.gcr.io/serlo-shared/grafana:6.2.2"
  description = "Docker image for grafana."
}

variable "grafana_admin_password" {
  description = "Admin password for grafana."
}

variable "grafana_serlo_password" {
  description = "Serlo (viewer) password for grafana."
}

variable "athene2_database_name" {
  description = "Name of athene2 database name"
  default     = "serlo"
}

variable "athene2_database_host" {
  description = "athene2 database host and port colon separated"
}

variable "athene2_database_username_readonly" {
  description = "Readonly user for athene2 database connection"
  default     = "serlo_readonly"
}

variable "athene2_database_password_readonly" {
  description = "Readonly password for athene2 database connection"
}

#
# application variables
#

variable "mysql_importer_image" {
  description = "image name of importer image"
  default     = "eu.gcr.io/serlo-shared/kpi-mysql-importer:latest"
}

variable "image_pull_policy" {
  description = "pull policy for the container image"
  default     = "Always"
}

variable "mysql_importer_interval_in_min" {
  description = "time interval to import new data from mysql database to postgres datbase"
  default     = 15
}

variable "mysql_importer_log_level" {
  description = "log level for importer"
  default     = "info"
}

variable "kpi_database_host" {
  description = "kpi database host"
}

variable "kpi_database_name" {
  description = "kpi database name"
  default     = "kpi"
}

variable "kpi_database_username_default" {
  description = "kpi database default user"
  default     = "serlo"
}
variable "kpi_database_password_default" {
  description = "kpi database default password"
}

variable "kpi_database_username_readonly" {
  description = "kpi database readonly user"
  default     = "serlo_readonly"
}

variable "kpi_database_password_readonly" {
  description = "kpi database readonly password"
}

variable "aggregator_image" {
  description = "image name of aggregator"
  default     = "eu.gcr.io/serlo-shared/kpi-aggregator:latest"
}

variable "mfnf_importer_image" {
  description = "image name of mfnf-importer"
  default     = "eu.gcr.io/serlo-shared/kpi-mfnf-importer:latest"
}
