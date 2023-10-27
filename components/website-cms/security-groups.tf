###
# AWS EC2 Security Group
###

resource "aws_security_group" "website-cms-lb" {
  name        = "website-cms-lb"
  description = "Ingress - Load Balancer"
  vpc_id      = aws_vpc.website-cms.id

  tags = {
    CostCenter = "website-cms"
  }
}

resource "aws_security_group_rule" "lb_ingress_internet_80" {
  description       = "Ingress from the internet to the load balancer (http)"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.website-cms-lb.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lb_ingress_internet_443" {
  description       = "Ingress from the internet to the load balancer (https)"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.website-cms-lb.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lb_egress_ecs" {
  description              = "Egress from load balancer to ECS"
  type                     = "egress"
  from_port                = var.app_port
  to_port                  = var.app_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.website-cms-lb.id
  source_security_group_id = aws_security_group.ecs_tasks.id
}

# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "cms-ecs-tasks-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.website-cms.id

  tags = {
    CostCenter = "website-cms"
  }  
}

resource "aws_security_group_rule" "ecs_ingress_lb" {
  description              = "Ingress to the ECS task from the load balancer"
  type                     = "ingress"
  from_port                = var.app_port
  to_port                  = var.app_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs_tasks.id
  source_security_group_id = aws_security_group.website-cms-lb.id
}

resource "aws_security_group_rule" "ecs_egress_database" {
  description              = "Egress from the ECS task to the database"
  type                     = "egress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs_tasks.id
  source_security_group_id = aws_security_group.website-cms-database.id
}

resource "aws_security_group_rule" "ecs_egress_internet" {
  description       = "Egress from the ECS task to the internet"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_tasks.id
  cidr_blocks       = ["0.0.0.0/0"]
}

###
# AWS RDS Security Group
###
# Traffic to the DB should only come from ECS
resource "aws_security_group" "website-cms-database" {
  name        = "website-cms-database"
  description = "Ingress - RDS instance"
  vpc_id      = aws_vpc.website-cms.id

  tags = {
    CostCenter = "website-cms"
  }
}

resource "aws_security_group_rule" "database_ingress_ecs" {
  description              = "Ingress to the database from the ECS task"
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.website-cms-database.id
  source_security_group_id = aws_security_group.ecs_tasks.id
}
