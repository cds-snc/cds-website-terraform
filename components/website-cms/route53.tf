resource "aws_route53_zone" "strapi" {
  name    = var.domain_name
  comment = "Hosted zone for ${var.domain_name}"

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
    Terraform             = true
  }
}

resource "aws_route53_record" "strapi_A" {
  zone_id = aws_route53_zone.strapi.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.cms-load-balancer.dns_name
    zone_id                = aws_lb.cms-load-balancer.zone_id
    evaluate_target_health = false
  }
}

import {
  to = aws_route53_record.strapi_A
  id = "${aws_route53_zone.strapi.zone_id}_${var.domain_name}_A"
}
