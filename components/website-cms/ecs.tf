resource "aws_ecs_cluster" "website-cms-cluster" {
  name = "website-cms-cluster"
}

data "template_file" "cms_app" {
  template = file("./task-definitions/cms_app.json.tpl")

  vars = {
    image                 = aws_ecr_repository.image-repository.repository_url
    fargate_cpu           = var.fargate_cpu
    fargate_memory        = var.fargate_memory
    aws_region            = "ca-central-1"
    awslogs-group         = aws_cloudwatch_log_group.cds-website-cms.name
    db_host               = aws_db_instance.website-cms-database.endpoint
    bucket_name           = var.asset_bucket_name
    aws_access_key_id     = var.strapi_aws_access_key_id
    aws_secret_access_key = var.strapi_aws_secret_access_key
  }
}

resource "aws_ecs_task_definition" "cds-website-cms" {
  family                   = "website-cms-task"
  execution_role_arn       = aws_iam_role.ecs-task-execution-role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.cms_app.rendered
}

resource "aws_ecs_service" "website-cms-ecs" {
  name            = "website-cms-ecs"
  cluster         = "website-cms-cluster"
  desired_count   = 1
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.cds-website-cms.arn

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.website-cms-public.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "cds-website-cms"
    container_port   = var.app_port
  }
}