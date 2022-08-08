variable "name_prefix" {
  default     = ""
  description = "Prefix environment name"
  type        = string
}

variable "subnets" {
  default     = []
  description = "Public subnets IDs for ALB"
  type        = list
}

variable "vpc_id" {
  default     = ""
  description = "The VPC ID"
  type        = string
}

variable "ssl_certificate" {
  default     = ""
  description = "A valid SSL certificate ARN"
  type        = string
}

variable "tags" {
  default     = {}
  description = "The metadata that you apply to the task definition to help you categorize and organize them"
  type        = map(string)
}

variable "target_group_port" {
  default     = "80"
  description = "The target group port number"
  type        = number
}