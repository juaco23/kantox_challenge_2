output "service_name" {
  value = aws_ecs_service.this.name  
}
output "ecs_role_arn" {
  value = aws_iam_role.service_role.arn
}
output "task_definition_family" {
  value = aws_ecs_task_definition.this.family
}
