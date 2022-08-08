resource "aws_codedeploy_app" "this" {
  compute_platform = "ECS"
  name             = "${var.name_prefix}-codedeploy-app"
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name               = aws_codedeploy_app.this.name
  deployment_config_name = "CodeDeployDefault.ECSLinear10PercentEvery1Minutes"
  deployment_group_name  = "${var.name_prefix}-codedeploy-dg"
  service_role_arn       = aws_iam_role.code_deploy.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.aws_lb_listener_green_arn]
      }

      test_traffic_route {
        listener_arns = [var.aws_lb_listener_blue_arn]
      }

      target_group {
        name = var.aws_lb_target_group_green_name
      }

      target_group {
        name = var.aws_lb_target_group_blue_name
      }
    }
  }
}

## CODE DEPLOY IAM ROLE


resource "aws_iam_role" "code_deploy" {
  name               = "${var.name_prefix}-code-deploy-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role = aws_iam_role.code_deploy.name
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/codedeploy_IAM_role.html
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}