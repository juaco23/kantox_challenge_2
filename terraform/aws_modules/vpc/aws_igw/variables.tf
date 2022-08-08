variable "vpc_id" {
  type = string
  description = "The ID of the VPC"
}

variable "environment" {
  type = string
  description = "Environment"
}

variable "name" {
  type = string
  description = "The name of the internet gateway"
}

variable "identifier_tags" {
  type    = map(string)
  description = "A mapping of identifier tags"
  default = {}
}

