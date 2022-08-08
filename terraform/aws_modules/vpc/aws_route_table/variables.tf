// module: aws_route_table

variable "propagating_vgws" {
  description = "A list of propagating VGWs"
  type    = list(any)
  default = []
}

variable "available_az" {
  description = "A list of available Availability Zones"
  type = list(any)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type = string
}

variable "cluster_name" {
  description = "The name of the cluster"
  type = string
}

variable "purpose" {
  description = "The purpose of the route table"
  type = string
}

variable "route_table_count" {
  description = "The number of route tables that will be created"
  type = number
}

variable "identifier_tags" {
  description = "A mapping of identifier tags"
  type    = map(string)
  default = {}
}

variable "s3_vpc_endpoint_id" {
  description = "The ID of the S3 endpoint"
  type    = string
  default = ""
}

variable "dynamodb_vpc_endpoint_id" {
  description = "The ID of the Dynamo endpoint"
  type    = string
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

