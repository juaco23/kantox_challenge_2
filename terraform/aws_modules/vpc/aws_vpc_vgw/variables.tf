variable "vpc_id" {
  description = "The ID of the VPC"
  type = string
}

variable "environment" {
  description = "Environment"
  type = string
}



variable "application" {
  description = "The name of the application"
  type = string
}

variable "tags" {
  description = "A mapping of tags"
  type    = map(string)
  default = {}
}

