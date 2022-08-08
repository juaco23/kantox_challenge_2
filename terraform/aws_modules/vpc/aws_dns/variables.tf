variable "base_dns" {
  type = string
  description = "The base DNS for the zone name"
}

variable "subdomain" {
  type = string
  description = "The subdomain for the zone name"
}

variable "environment" {
  type = string
  description = "environment"
}

variable "parent_zone" {
  type = string
  description = "The DNS parent zone"
}

variable "region" {
  type = string
  description = "Region"
}

variable "identifier_tags" {
  type    = map(string)
  description = "A mapping of identifier tags"
  default = {}
}

variable "enable_dns" {
  type = number
  description = "If number is 0 no record will be created"
}

