## IAM DEFAULT POLICY

resource "aws_iam_role_policy_attachment" "default_policy" {
  role       = aws_iam_role.service_role.name
  policy_arn = data.aws_iam_policy.default_policy.arn
}

## IAM ROLE

resource "aws_iam_role" "service_role" {

  name = "${var.name_prefix}-${var.name}-ecs-role"

  assume_role_policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}


resource "aws_iam_policy" "ecs_service_elb" {
  name        = "${var.name_prefix}-${var.name}-elb-policy"
  path        = "/"
  description = "Allow ECS service to ELB"
  policy      = data.aws_iam_policy_document.ecs_service_elb.json
}

resource "aws_iam_policy" "ecs_service_scaling" {
  name        = "${var.name_prefix}-${var.name}-asg-policy"
  path        = "/"
  description = "Allow ECS service to ASG"
  policy      = data.aws_iam_policy_document.ecs_service_scaling.json
}

resource "aws_iam_policy" "ecs_service_secrets_manager" {
  name        = "${var.name_prefix}-${var.name}-sm-policy"
  path        = "/"
  description = "Allow ECS service to SECRETS MANAGER"
  policy      = data.aws_iam_policy_document.ecs_service_secrets_manager.json
}

resource "aws_iam_role_policy_attachment" "ecs_service_elb" {
  role       = aws_iam_role.service_role.name
  policy_arn = aws_iam_policy.ecs_service_elb.arn
}

resource "aws_iam_role_policy_attachment" "ecs_service_scaling" {
  role       = aws_iam_role.service_role.name
  policy_arn = aws_iam_policy.ecs_service_scaling.arn
}

resource "aws_iam_role_policy_attachment" "ecs_service_secrets_manager" {
  role       = aws_iam_role.service_role.name
  policy_arn = aws_iam_policy.ecs_service_secrets_manager.arn
}

## ECS TASK DEFINITION

resource "aws_ecs_task_definition" "this" {
  family = "${var.name_prefix}-${var.name}-td"

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = var.task_cpu
  memory = var.task_memory

  execution_role_arn    = aws_iam_role.service_role.arn
  task_role_arn         = aws_iam_role.service_role.arn
  container_definitions = var.container_definition

  tags = var.tags
}

## SECURITY GROUP

resource "aws_security_group" "this" {
  name   = "${var.name_prefix}-${var.name}-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow ingress traffic"
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    security_groups  = [var.alb_sg_id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

## CLOUDWATCH LOG GROUP

resource "aws_cloudwatch_log_group" "this" {
  name              = "${var.name_prefix}-${var.name}-lg"
  retention_in_days = 7
  tags              = var.tags
}

## ECS SERVICE

resource "aws_ecs_service" "this" {
  name            = "${var.name_prefix}-${var.name}-srv"
  cluster         = data.aws_ecs_cluster.this.cluster_name
  task_definition = "${aws_ecs_task_definition.this.family}:${aws_ecs_task_definition.this.revision}"

  health_check_grace_period_seconds = 0
  propagate_tags                    = "TASK_DEFINITION"
  launch_type                       = "FARGATE"

  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.this.id]
    subnets          = var.applications_subnets
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.name
    container_port   = var.container_port
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      load_balancer,
      desired_count,
      task_definition
    ]
  }

  desired_count                      = 1
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  tags = var.tags
}

## AUTOS SCALLING

resource "aws_appautoscaling_target" "this_target" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${data.aws_ecs_cluster.this.cluster_name}/${var.name_prefix}-${var.name}-srv"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "this_memory" {
  name               = "${var.name_prefix}-${var.name}-memory-asg-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this_target.resource_id
  scalable_dimension = aws_appautoscaling_target.this_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = var.memory_target_value
  }
}

resource "aws_appautoscaling_policy" "this_cpu" {
  name               = "${var.name_prefix}-${var.name}-cpu-asg-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this_target.resource_id
  scalable_dimension = aws_appautoscaling_target.this_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = var.cpu_target_value
  }
}
