variable "cgw_ip_address" {
  description = "The IP address of the customer gateway"
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

variable "bgp_asn" {
  description = "Border Gateway Protocol Autonomous Systems Number"
  type = any
  default = "65000"
}

variable "tags" {
  description = "A mapping of tags"
  type    = map(string)
  default = {}
}

