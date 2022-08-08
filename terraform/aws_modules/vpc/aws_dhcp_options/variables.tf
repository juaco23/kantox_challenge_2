// module: vpc_dhcp_options

variable "domain_names" {
  type = map(string)
  description = "A map of domain names"
  default = {
    us-east-1 = "ec2.internal"
  }
}

variable "domain_name_servers" {
  type = list(any)
  description = "A list of domain name servers"
  default = ["AmazonProvidedDNS"]
}

variable "environment" {
  type = string
  description = "Environment"
}

variable "vpc_id" {
  type = string
  description = "The ID of the VPC"
}

variable "update_dhcp_options" {
  type = string
  description = "Determines if an dhcp_options resource will be created"
  default = "1"
}

variable "identifier_tags" {
  type    = map(string)
  description = "A mapping of tags"
  default = {}
}

