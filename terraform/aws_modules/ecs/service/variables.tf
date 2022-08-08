
#SERVICE 
variable "target_group_arn" {
  description = "Green target group name"
  type        = string
}
## ECS TASK DEFINITION 

variable "name_prefix" {
  default     = ""
  description = "Prefix environment name"
  type        = string
}

variable "tags" {
  default     = {}
  description = "The metadata that you apply to the task definition to help you categorize and organize them"
  type        = map(string)
}

variable "task_cpu" {
  default     = 0
  description = "CPU defined at the task level"
  type        = number
}

variable "task_memory" {
  default     = 0
  description = "MEMORY defined at the task level"
  type        = number
}

variable "container_port" {
  default     = 0
  description = "Container port"
  type        = number
}

variable "name" {
  default     = ""
  description = "Prefix environment name"
  type        = string
}

variable "container_definition" {
  default     = ""
  description = "Task definitions, container definitions"
  type        = string
}

# variable "health_check_path" {
#   default     = "/"
#   description = "Health Check configuration block"
#   type        = string
# }

# variable "type" {
#   description = "Load Balancer type"
#   type        = string
# }

## ASG

variable "max_capacity" {
  type        = number
  description = "Max services for scale up"
  default     = 1
}

variable "min_capacity" {
  type        = number
  description = "Min services for scale up"
  default     = 1
}

variable "cpu_target_value" {
  type        = number
  description = "Value for the cpu target to do autoscale"
  default     = 50
}

variable "memory_target_value" {
  type        = number
  description = "Value for the memory target to do autoscale"
  default     = 50
}
variable "applications_subnets" {
  description = "The private application subnets"
}
variable "vpc_id" {
  description = "The VPC id"
}

variable "alb_sg_id" {
  description = "The ALB SG id to allow traffic inside the service"
}

