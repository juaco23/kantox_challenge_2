# module: aws_vpc_endpoint

output "vpc_endpoint_id" {
  description = "The VPC endpoint ID"
  value = aws_vpc_endpoint.vpc_endpoint[0].id
}

output "vpc_endpoint_prefix_list_id" {
  description = "The VPC endpoint prefix list ID "
  value = aws_vpc_endpoint.vpc_endpoint[0].prefix_list_id
}

output "vpc_endpoint_cidr_blocks" {
  description = "The VPC endpoint CIDR block"
  value = aws_vpc_endpoint.vpc_endpoint[0].cidr_blocks
}

