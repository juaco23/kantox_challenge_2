variable "name_prefix" {
  default     = ""
  description = "Prefix environment name"
  type        = string
}
variable "certificate_arn" {
  default     = ""
  description = "A valid ssl certificate arn"
  type        = string
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

variable "aws_lb_listener_green_arn" {
  type        = string
  description = "The green Listener ARN"
  default     = ""
}

variable "aws_lb_listener_blue_arn" {
  type        = string
  description = "The blue Listener ARN"
  default     = ""
}

variable "aws_lb_target_group_green_name" {
  type        = string
  description = "The green TG name"
  default     = ""
}

variable "aws_lb_target_group_blue_name" {
  type        = string
  description = "The blue TG name"
  default     = ""
}




