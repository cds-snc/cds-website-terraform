resource "aws_route53_zone" "strapi" {
  name    = var.domain_name
  comment = "Hosted zone for ${var.domain_name}"

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
    Terraform             = true
  }
}