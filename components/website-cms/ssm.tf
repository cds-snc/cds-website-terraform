resource "aws_ssm_parameter" "db_password" {
  name  = "db_password"
  type  = "String"
  value = var.rds_cluster_password
}

resource "aws_ssm_parameter" "github_token" {
  name  = "github_token"
  type  = "String"
  value = var.github_token
}

resource "aws_ssm_parameter" "aws_access_key_id" {
  name  = "aws_access_key_id"
  type  = "String"
  value = var.strapi_aws_access_key_id
}

resource "aws_ssm_parameter" "aws_secret_access_key" {
  name  = "aws_access_key_id"
  type  = "String"
  value = var.strapi_aws_secret_access_key
}