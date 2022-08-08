variable "environment" {
  description = "Environment"
  type = string
}

variable "name" {
  description = "The name of the VPC"
  type = string
}

variable "cidr_block" {
  description = "The CIDR block of the VPC"
  type = string
}

variable "instance_tenancy" {
  default = "The tenancy of the instances that will be created inside the VPC"
  type = string
}

variable "enable_dns_support" {
  default = "Whether DNS support will be enabled"
  type = any
}

variable "enable_dns_hostnames" {
  description = "Whether the DNS hostnames will be enabled"
  type = string
  default = "false"
}

variable "enable_classiclink" {
  description = "Whether Classiclink will be enabled"
  type = string
  default = "false"
}

variable "enable_classiclink_dns_support" {
  description = "Whether DNS support for Classiclink will be enabled"
  type = string
  default = "false"
}

variable "assign_generated_ipv6_cidr_block" {
  description = "Whether an IPv6 CIDR block will be assigned"
  type = string
  default = "false"
}

variable "identifier_tags" {
  description = "A mapping of identifier tags"
  type    = map(string)
  default = {}
}

