##OIDC github
variable "repo_name" {
  type        = string
  description = "The repository name to connect to AWS by OIDC"
  default     = ""
}

variable "ecs_role_arn" {
  type        = string
  description = "The ECS role arn"
  default     = ""
}

variable "client_id_list" {
  description = "Audience that identifies the application that is registered with an OpenID Connect provider"
  type        = list(string)
  default = [
    "sts.amazonaws.com"
  ]
}

variable "ecs_cluster_name" {
  type        = string
  description = "The ECS Cluster Name"
  default     = ""
}

variable "ecs_service_name" {
  type        = string
  description = "The ECS Service Name"
  default     = ""
}


variable "codedeploy_application_name" {
  type        = string
  description = "The CodeDeploy application name"
  default     = ""
}

variable "codedeploy_dg" {
  type        = string
  description = "The CodeDeploy Deployment Group name"
  default     = ""
}
variable "region" {
  type        = string
  description = "Region"
  default     = "us-east-1"
}

variable "ecr_repository_arn" {
  type        = string
  description = "The ECR repository ARN"
  default     = "us-east-1"
}

