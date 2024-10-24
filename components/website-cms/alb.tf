# alb.tf

resource "aws_alb" "cms-load-balancer" {
  name            = "cms-load-balancer"
  subnets         = aws_subnet.website-cms-public.*.id
  security_groups = [aws_security_group.website-cms-lb.id]
  internal        = false #tfsec:ignore:AWS005

  drop_invalid_header_fields = true
  enable_deletion_protection = true

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
    Terrafrom             = true
  }
}

resource "aws_alb_target_group" "app" {
  name        = "cms-target-group"
  port        = var.app_port
  protocol    = "HTTP" #tfsec:ignore:AWS004 - uses plain HTTP instead of HTTPS
  vpc_id      = aws_vpc.website-cms.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP" #tfsec:ignore:AWS004 - uses plain HTTP instead of HTTPS
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.cms-load-balancer.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-FIPS-2023-04"
  certificate_arn   = aws_acm_certificate_validation.strapi.certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
    Terrafrom             = true
  }
}