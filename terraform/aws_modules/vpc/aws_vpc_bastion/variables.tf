# module: bastion

variable "base_route53_domain" {
  description = "The base Route53 domain"
  type = string
}

variable "route53_zone_id" {
  description = "The Route53 zone ID"
  type = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type = string
}

variable "enable_bastion" {
  description = "If the value is 0 the bastion creation won't be enabled"
  type = any
  default = "1"
}

variable "user" {
  description = "User"
  type = string
}

variable "cluster_name" {
  description = "The name of the cluster"
  type = string
}

variable "num_az" {
  description = "Number of AZs specified"
  type = any
}

variable "environment" {
  description = "Environment"
  type = string
}

variable "instance_type" {
  description = "The type of instance for the bastion"
  type = string
  default = "t2.nano"
  
}

variable "available_az" {
  description = "A list of available Availability zones"
  type = list(any)
}

variable "public_subnets" {
  description = "A list of public subnets"
  type = list(any)
}

variable "services_subnets" {
  description = "A list of service subnets"
  type = list(any)
}

variable "identifier_tags" {
  description = "A mapping of identifier tags"
  type    = map(string)
  default = {}
}

