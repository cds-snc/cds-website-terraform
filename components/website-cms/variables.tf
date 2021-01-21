variable "app_port" {
  default = 1337
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
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