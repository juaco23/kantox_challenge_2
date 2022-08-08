// module: aws_subnet_setup

variable "name" {
  description = "The name of the subnet"
  type = string
}

variable "environment" {
  description = "Environment"
  type = string
}

variable "available_az" {
  description = "A list of available Availability Zones"
  type = list(any)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type = string
}

variable "is_public" {
  description = "Whether or not the VPC is public"
  type = bool
}

variable "subnet_count" {
  description = "The number of subnets that will be created"
  type = number
}

variable "subnet_size" {
  description = "The size of the subnet"
  type = string
}

variable "subnet_type" {
  description = "The type of the subnet"
  type = string
}

variable "ngw_count" {
  description = "The number of NAT gateways"
  type = number
  default = 0
}

variable "gw_count" {
  description = "The number of VGW or IGW"
  type = number
  default = 0
}

variable "cidr_block" {
  description = "The VPC's CIDR block"
  type = string
}

variable "subnet_assignment_list" {
  description = "A list of subnet CIDR for assignment"
  type = list(any)
}

variable "ngw_id_list" {
  description = "A list of IDs of NAT Gateways"
  type    = list(any)
  default = []
}

variable "gw_id" {
  description = "The ID of the VGW/IGW"
  type = string
  default = ""
}

variable "dst_cidr_block" {
  description = "The destination CIDR block"
  type = string
  default = "0.0.0.0/0"
}

variable "subnet_tag_values" {
  description = "A mapping of subnet tag values"
  type    = map(string)
  default = {}
}

variable "identifier_tags" {
  description = "A mapping of identifier tags"
  type    = map(string)
  default = {}
}

variable "propagating_vgws" {
  description = "A list of propagating VGWs"
  type    = list(any)
  default = []
}

variable "s3_vpc_endpoint_id" {
  description = "The ID of the S3 endpoint"
  type = string
  default = ""
}

variable "dynamodb_vpc_endpoint_id" {
  description = "The ID of the Dynamo endpoint"
  type = string
  default = ""
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

