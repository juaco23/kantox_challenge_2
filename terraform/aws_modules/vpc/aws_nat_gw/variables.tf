variable "ngw_count" {
  description = "The number of NAT gateways that will be created"
  type  = number
}

variable "nat_subnet_ids" {
  description = "A list of subnet IDs for the NATs"
  type = list(any)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type = string
}

variable "environment" {
  description = "Environment"
  type = string
}

variable "name" {
  description = "The name of the NAT Gateway"
  type = string
}


variable "identifier_tags" {
  description = "A mapping of identifier tags"
  type    = map(string)
  default = {}
}

variable "owner" {
  description = "The name of the NAT Gateway"
  type = string
}