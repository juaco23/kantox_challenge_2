output "igw_id" {
  description = "The ID of the internet gateway"
  value = module.internet_gateway.igw_id
}

output "nat_gws" {
  description = "NAT gateways"
  value = module.nat_gateways.ngws
}

output "services_subnets" {
  description = "The service subnets"
  value = module.services_subnets_setup.subnets
}

output "nat_subnets" {
  description = "The NAT subnets"
  value = module.nat_subnets_setup.subnets
}

output "dns_zone_name" {
  description = "The DNS zone name"
  value = module.vpc_dns.zone_name
}

output "dns_zone_id" {
  description = "The DNS zone ID"
  value = module.vpc_dns.zone_id
}

output "bastion_private_key_pem" {
  description = "The bastion's private key pem"
  value = module.bastion.private_key_pem
}

output "bastion_dns_record" {
  description = "The bastion DNS record"
  value = module.bastion.bastion_dns_record
}

output "dynamodb_vpc_endpoint_id" {
  description = "The DynamoDB endpoint ID"
  value = var.enable_dynamodb_vpc_endpoint == "1" ? module.dynamodb_vpc_endpoint.vpc_endpoint_id : ""
}

output "s3_vpc_endpoint_id" {
  description = "The S3 endpoint ID"
  value = var.enable_s3_vpc_endpoint == "1" ? module.s3_vpc_endpoint.vpc_endpoint_id : ""
}
