variable "app_port" {
  default = 1337
}

# RDS DB
variable "rds_cluster_host" {
  type = string
}
variable "rds_db_name" {
  type = string
}

variable "rds_db_user" {
  type = string
}
variable "rds_db_password" {
  type = string
}

variable "rds_cluster_password" {
  type = string
}