data "template_file" "container-definition" {
  template = file("${path.module}/container_definitions.json.tpl")
  vars = {
    aws_ecr_url               = var.aws_ecr_url
    tag                       = var.container_image_version
    cloudwatch_log_group_name = var.cloudwatch_log_group_name
    cloudwatch_log_prefix     = var.cloudwatch_log_prefix
    aws_region                = var.aws_region

  }
}

resource "aws_cloudwatch_log_group" "spitlog" {
  name = "spitlog"
}

resource "aws_ecs_cluster" "spitlog" {
  name = "spitlog"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    App = "spitlog"
  }
}

resource "aws_ecs_cluster_capacity_providers" "spitlog" {
  cluster_name = aws_ecs_cluster.spitlog.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "spitlog" {
  family                   = "spitlog"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  requires_compatibilities = ["FARGATE"]
  container_definitions    = data.template_file.container-definition.rendered
}

resource "aws_ecs_service" "spitlog" {
  name            = "splitlog"
  cluster         = aws_ecs_cluster.spitlog.id
  task_definition = aws_ecs_task_definition.spitlog.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [aws_subnet.private_subnet.id]
  }

  tags = {
    App = "spitlog"
  }
}
