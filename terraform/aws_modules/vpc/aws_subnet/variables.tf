// module: aws_subnet

// default:   enable subnet creation.  Useful for determining if private subnet
//      should be created based on whether private subnet should be created in the first place
// this parameter should be better removed entirely
variable "enable_subnet" {
  description = "If the value is 0, the subnet creation won't be enabled"
  type = string
  default = "1"
}

// this is the cidr_block of the entire vpc.  Specific subnets will be created based on the subnet_offset
variable "cidr_block" {
  description = "The CIDR block of the VPC"
  type = string
}

variable "subnet_size" {
  description = "The size of the subnet"
  type = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type = string
}

variable "available_az" {
  description = "A list of available Availability Zones"
  type = list(any)
}

variable "environment" {
  description = "Environment"
  type = string
}

variable "number_of_az" {
  description = "The number of availability zones"
  type = string
  default = "3"
}

variable "subnet_type" {
  description = "The type of subnet that will be created"
  type = string
}

variable "tag_values" {
  description = "A mapping of tag values"
  type    = map(string)
  default = {}
}

variable "subnet_count" {
  description = "The number of subnets that will be created"
  type = number
}

variable "subnet_assignment" {
  description = "A list of subnet CIDR for assignment"
  type = list(any)
}

variable "identifier_tags" {
  description = "A mapping of identifier tags"
  type    = map(string)
  default = {}
}

variable "is_public" {
  description = "Whether or not the subnet will be public"
  type = bool
}

variable "name" {
  description = "The name of the subnet"
  type = string
}

