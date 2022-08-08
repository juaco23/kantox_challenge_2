// module: aws_subnet_setup
output "subnets" {
  value = module.subnets.subnets
  description = "The subnets created by the module"
}

output "subnet_ids" {
  value = module.subnets.subnet_ids
  description = "The ID of the subnets"
}

output "subnet_cidrs" {
  value = module.subnets.subnet_cidrs
  description = "The CIDR blocks of the subnets"
}

output "route_table_ids" {
  value = module.route_tables.route_table_ids
  description = "The ID of the route table"
}

