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
variable "rds_cluster_password" {
  type = string
}

# Env Vars for the container
variable "asset_bucket_name" {
  type = string
}

variable "strapi_aws_access_key_id" {
  type = string
}

variable "strapi_aws_secret_access_key" {
  type = string
}