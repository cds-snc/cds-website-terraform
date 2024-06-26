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

resource "aws_ssm_parameter" "admin_jwt_secret" {
  name  = "/website/admin_jwt_secret"
  type  = "SecureString"
  value = var.strapi_admin_jwt_secret
}

resource "aws_ssm_parameter" "api_token_salt" {
  name  = "/website/api_token_salt"
  type  = "SecureString"
  value = var.strapi_api_token_salt
}