# module: aws_vpc_endpoint

variable "vpc_id" {
  description = "The ID of the VPC"
  type = string
}

variable "service" {
  description = "The name of the service"
  type = string
}

variable "enable_vpc_endpoint" {
  description = "If the value is 0 the VPC endpoint won't be enabled"
  type = any
  default = "1"
}

variable "private_dns_enabled" {
  description = "Whether the private DNS will be enabled"
  type = bool
  default = false
}

