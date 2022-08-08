# module: aws_vpc_endpoint

variable "vpc_id" {
  description = "The ID of the VPC"
  type = string
}

variable "service" {
  description = "The service name"
  type = string
}

variable "enable_vpc_endpoint" {
  description = "If the value is 0, the VPC endpoint won't be enabled"
  type    = string
  default = "1"
}

variable "with_security_group" {
  default = "0"
}

variable "private_dns_enabled" {
  description = "Whether the private DNS will be enabled"
  type = bool
  default = false
}

variable "aws_security_group_id" {
  description = "The ID of the AWS security group"
  type = string
  default = ""
}

