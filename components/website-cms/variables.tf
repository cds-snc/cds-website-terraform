variable "app_port" {
  default = 1337
}

variable "billing_tag_key" {
  type        = string
  description = "Billing tag name to apply to resources"
}

variable "billing_tag_value" {
  type        = string
  description = "Billing tag value to apply to resources"
}

variable "domain_name" {
  type        = string
  description = "Domain name of the Strapi instance"
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

# RDS database
# The password for the database can include any printable ASCII character except /, ", @, or a space
variable "rds_cluster_password" {
  description = "RDS cluster password"
  sensitive   = true
  type        = string
}

# Env Vars for the container
variable "asset_bucket_name" {
  type = string
}

variable "strapi_admin_jwt_secret" {
  description = "Strapi Admin JWT Secret"
  sensitive   = true
  type        = string
}

# This github token makes a call to run action here https://github.com/cds-snc/cds-website-pr-bot
variable "github_token" {
  description = "Github token"
  sensitive   = true
  type        = string
}
