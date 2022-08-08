# OUTPUTS 

output "CONTAINER_NAME" {
  value       = var.container_name
  description = "The name of your container"
}

output "ECS_CLUSTER_NAME" {
  value       = module.ecs_cluster.cluster_name
  description = "The ECS Cluster Name"

}

output "ECS_SERVICE_NAME" {
  value       = module.ecs_services.service_name
  description = "The ECS Service Name"

}

output "CODE_DEPLOY_APPLICATION" {
  value       = module.codedeploy.aws_codedeploy_app_name
  description = "The CodeDeploy Application name"

}

output "CODE_DEPLOY_DG" {
  value       = module.codedeploy.deployment_group_name
  description = "The CodeDeploy Deployment Group name"

}

output "DEPLOY_ROLE" {
  value       = module.oidc_github.github_actions_arn
  description = "The ARN of the GitHub Role, which is used to deploy by Github Actions"

}

output "ECR_REPOSITORY" {
  value       = "${local.name_prefix}-repo"
  description = "The ECR Repository name"

}

output "TASK_DEFINITION_FAMILY" {
  value       = module.ecs_services.task_definition_family
  description = "The ECS TaskDefinition Family"

}

output "alb_dns" {
  value       = module.alb.alb_dns
  description = "The Application Load Balancer DNS"

}


