variable "name" {
  description = "The name of the security group"
  type = string
}

variable "description" {
  description = "The description of the security group"
  type = string
  default = "Managed by Terraform"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
}

variable "sg_ingress_rules" {
  description = "A list of ingress rules for the security group"
  type    = list(any)
  default = []
}

variable "cidr_ingress_rules" {
  description = "A list of ingress rules CIDRs"
  type    = list(any)
  default = []
}