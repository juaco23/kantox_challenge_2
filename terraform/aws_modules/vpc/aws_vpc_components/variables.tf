variable "region" {
  description = "The Region"
  type = string
}

variable "available_az" {
  description = "A list of available Availability zones"
  type = list(any)
}

variable "num_az" {
  description = "Number of AZs specified"
  type = any
}

variable "user" {
  description = "The User"
  type = string
}

variable "name" {
  description = "The name of the resource"
  type = string
}

variable "environment" {
  description = "Environment"
  type = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type = string
}

variable "forward_zones" {
  description = "A mapping of forward zones"
  type    = map(any)
  default = {}
}

variable "svc_subnet_size" {
  description = "The service subnet size"
  type = any
  default = "24"
}

variable "subnet_offset" {
  description = "The subnet offset"
  type = any
  default = "3"
}

variable "subnet_assignment" {
  description = "A mapping of subnet assignments"
  type = map(any)
}

variable "subnet_count" {
  description = "A mapping of subnet counts"
  type = map(any)
}

variable "subnet_tag_values" {
  description = "A mapping of subnet tag values"
  type = map(any)
}

variable "identifier_tags" {
  description = "A mapping of identifier tags"
  type    = map(any)
  default = {}
}

variable "enable_flow_logs" {
  description = "If the value is 0 the flow logs won't be enabled"
  default = "0"
}

variable "propagating_vgws" {
  description = "A list of propagating vgws"
  type    = list(any)
  default = []
}

variable "enable_unbound" {
  description = "If the value is 0 the unbound won't be enabled"
  type = any
  default = "0"
}

variable "enable_bastion" {
  description = "If the value is 0 the bastion won't be enabled"
  type = any
  default = "1"
}

variable "enable_dns_zone" {
  description = "If the value is 0 the bastion won't be enabled"
  default = "1"
}

variable "base_route53_domain" {
  description = "The base Route53 domain"
  type = string
}

variable "route53_zone_id" {
  description = "The Route53 zone ID"
  type = string
}

variable "enable_s3_vpc_endpoint" {
  description = "If the value is 0, the S3 endpoint won't be enabled"
  type    = string
  default = "0"
}

variable "enable_dynamodb_vpc_endpoint" {
  description = "If the value is 0, the Dynamo endpoint won't be enabled"
  type    = string
  default = "0"
}

variable "enable_ops_peering_routes" {
  description = "If the value is 0, the OPS peering routes won't be enabled"
  type = string
  default = "0"
}

variable "ops_peering_id" {
  description = "The ID of the OPS peering"
  type = string
  default = "0"
}

variable "ops_cidr" {
  description = "The CIDR of the OPS"
  type = string
  default = "0"
}
