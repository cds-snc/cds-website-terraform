# alb.tf

resource "aws_alb" "cms-load-balancer" {
  name            = "cms-load-balancer"
  subnets         = aws_subnet.website-cms-public.*.id
  security_groups = [aws_security_group.website-cms-lb.id]
  internal        = false #tfsec:ignore:AWS005
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
  port              = 80
  protocol          = "HTTP" #tfsec:ignore:AWS004 - uses plain HTTP instead of HTTPS

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}