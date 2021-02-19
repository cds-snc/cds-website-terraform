###
# AWS WAF - Assets
###
resource "aws_wafv2_web_acl" "assets" {
  provider = aws.ca-central-1

  name  = "assets"
  scope = "REGIONAL"

  default_action {
    allow {}
  }
}