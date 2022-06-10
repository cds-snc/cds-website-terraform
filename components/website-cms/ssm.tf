resource "aws_ssm_parameter" "db_password" {
  name  = "/website/db_password"
  type  = "SecureString"
  value = var.rds_cluster_password
}

resource "aws_ssm_parameter" "github_token" {
  name  = "/website/github_token"
  type  = "SecureString"
  value = var.github_token
}

resource "aws_ssm_parameter" "aws_access_key_id" {
  name  = "/website/aws_access_key_id"
  type  = "SecureString"
  value = var.strapi_aws_access_key_id
}

resource "aws_ssm_parameter" "aws_secret_access_key" {
  name  = "/website/aws_secret_access_key"
  type  = "SecureString"
  value = var.strapi_aws_secret_access_key
}

resource "aws_ssm_parameter" "admin_jwt_secret" {
  name  = "/website/admin_jwt_secret"
  type  = "SecureString"
  value = var.strapi_admin_jwt_secret
}
