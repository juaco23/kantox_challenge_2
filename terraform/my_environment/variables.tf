# OIDC github
####################################################################################
variable "repo_name" {
  type        = string
  description = "The repository name to connect to AWS to GitHub Actions"
}

variable "client_id_list" {
  description = "Audience that identifies the application that is registered with an OpenID Connect provider"
  type        = list(string)
}
####################################################################################


## GENERAL
####################################################################################
variable "environment" {
  type        = string
  description = "Environment name"
}

variable "application_name" {
  type        = string
  description = "Application name"
}

variable "region" {
  type        = string
  description = "Region"
  default     = "us-east-1"
}
####################################################################################


## NETWORKING VARIABLES
####################################################################################
variable "availability_zones" {
  type        = list(any)
  description = "A list of availability zones"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block of the vpc"
}

variable "subnet_size" {
  type        = string
  description = "Subnet size"
}

variable "subnet_assignment" {
  type        = map(string)
  description = "subnet assignment"
  default = {
    "public"      = "1,2"
    "application" = "3,4"
  }
}

variable "instance_tenancy" {
  type        = string
  description = "The tenancy of the instances that will be created inside the VPC"
  default     = "default"
}
####################################################################################


## ECS
####################################################################################

## ECS CLUSTER

variable "container_insights" {
  description = "Enable or disable Container Insights"
  type        = string
}

## ECS SERVICES

variable "container_name" {
  type        = string
  default     = ""
  description = "The name of your container"
}

## ECS TASK DEFINITION

variable "tags" {
  default     = {}
  description = "The metadata that you apply to the task definition to help you categorize and organize them"
  type        = map(string)
}

variable "task_cpu" {
  description = "CPU defined at the task level"
  type        = number
}

variable "task_memory" {
  description = "MEMORY defined at the task level"
  type        = number
}

variable "container_port" {
  description = "Container port"
  type        = number
}


variable "container_definition" {
  default     = ""
  description = "Task definitions, container definitions"
  type        = string
}

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
####################################################################################


#ALB
####################################################################################

variable "ssl_certificate" {
  default     = ""
  description = "A valid SSL certificate ARN"
  type        = string
}
