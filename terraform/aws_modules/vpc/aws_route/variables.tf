// module: aws_route

// gw = igw or vgw
variable "gw_count" {
  description = "The amount of igw or vgw"
  type = number
  default = "0"
}

variable "ngw_count" {
  description = "The amount of NAT gateways"
  type = number
  default = "0"
}

variable "vpc_peering_count" {
  description = "The amount of VPC peering"
  type = string
  default = "0"
}

variable "instance_count" {
  description = "The amount of instances"
  type = string
  default = "0"
}

variable "gw_id_list" {
  description = "A list of igw or vgw IDs"
  type    = list(any)
  default = []
}

variable "ngw_id_list" {
  description = "A list of NAT gateways' IDs"
  type    = list(any)
  default = []
}

variable "vpc_peering_id" {
  description = "The ID of the VPC peering"
  type = string
  default = ""
}

variable "instance_id" {
  description = "A list of the instances IDs"
  type    = list(any)  
  default = []
}

variable "route_table_ids" {
  description = "List of route table ids"
  type = list(any)
}

variable "dst_cidr_block" {
  type = string
  description = "The CIDR block of the destination"
}

