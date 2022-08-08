// module: aws_vpc_components

// if subnets are to be parcelled out to e.g. /24 -- leaving the rest of the CIDR empty to be provisioned down to specific subnet types down the road
// need to be able to calculate the subnet_offset when creating the individual subnets
data "template_file" "svc_offset_to_assigned_size" {
  template = "$${val}"

  vars {
    val = var.svc_subnet_size - element(split("/", data.aws_vpc.current.cidr_block), 1)
  }
}

data "aws_vpc" "current" {
  id = var.vpc_id
}

module "vpc_dns" {
  source          = "../aws_dns"
  enable_dns      = var.enable_dns_zone
  base_dns        = var.base_route53_domain
  subdomain       = var.user
  environment     = var.environment
  parent_zone     = var.route53_zone_id
  region          = var.region
  identifier_tags = var.identifier_tags
}

module "internet_gateway" {
  source          = "../aws_igw"
  name            = var.name
  vpc_id          = var.vpc_id
  environment     = var.environment
  identifier_tags = var.identifier_tags
}

module "nat_subnets_setup" {
  source                       = "../aws_subnet_setup"
  name                         = var.name
  gw_count                     = var.num_az
  gw_id                        = module.internet_gateway.igw_id
  vpc_id                       = var.vpc_id
  available_az                 = var.available_az
  is_public                    = true
  subnet_count                 = var.num_az
  user                         = var.user
  environment                  = var.environment
  subnet_size                  = "27"
  cidr_block                   = cidrsubnet(data.aws_vpc.current.cidr_block, 3, 0)
  subnet_assignment_list       = split(",", lookup(var.subnet_assignment, "nat", 0))
  subnet_type                  = "nat"
  subnet_tag_values            = var.subnet_tag_values
  identifier_tags              = var.identifier_tags
  propagating_vgws             = var.propagating_vgws
  s3_vpc_endpoint_id           = var.enable_s3_vpc_endpoint == "1" ? module.s3_vpc_endpoint.vpc_endpoint_id : ""
  enable_s3_vpc_endpoint       = var.enable_s3_vpc_endpoint
  dynamodb_vpc_endpoint_id     = var.enable_dynamodb_vpc_endpoint == "1" ? module.dynamodb_vpc_endpoint.vpc_endpoint_id : ""
  enable_dynamodb_vpc_endpoint = var.enable_dynamodb_vpc_endpoint
}

module "nat_gateways" {
  source         = "../aws_nat_gw"
  environment    = var.environment
  name           = var.name
  vpc_id         = var.vpc_id
  ngw_count      = var.num_az
  nat_subnet_ids = module.nat_subnets_setup.subnets["id"]
}

module "services_subnets_setup" {
  source                       = "../aws_subnet_setup"
  name                         = var.name
  ngw_count                    = var.num_az
  ngw_id_list                  = module.nat_gateways.ngw_ids
  vpc_id                       = var.vpc_id
  available_az                 = var.available_az
  is_public                    = false
  subnet_count                 = var.num_az
  user                         = var.user
  environment                  = var.environment
  subnet_size                  = var.svc_subnet_size
  cidr_block                   = data.aws_vpc.current.cidr_block
  subnet_assignment_list       = split(",", lookup(var.subnet_assignment, "services", 0))
  subnet_type                  = "services"
  subnet_tag_values            = var.subnet_tag_values
  identifier_tags              = var.identifier_tags
  propagating_vgws             = var.propagating_vgws
  s3_vpc_endpoint_id           = var.enable_s3_vpc_endpoint == "1" ? module.s3_vpc_endpoint.vpc_endpoint_id : ""
  enable_s3_vpc_endpoint       = var.enable_s3_vpc_endpoint
  dynamodb_vpc_endpoint_id     = var.enable_dynamodb_vpc_endpoint == "1" ? module.dynamodb_vpc_endpoint.vpc_endpoint_id : ""
  enable_dynamodb_vpc_endpoint = var.enable_dynamodb_vpc_endpoint
  enable_ops_peering_routes    = var.enable_ops_peering_routes
  ops_peering_id               = var.ops_peering_id
  ops_cidr                     = var.ops_cidr
}

module "unbound" {
  source           = "../unbound"
  vpc_id           = var.vpc_id
  available_az     = var.available_az
  cluster_name     = "${var.user}-${var.environment}-${var.region}"
  environment      = var.environment
  num_az           = var.num_az
  services_subnets = module.services_subnets_setup.subnets["id"]
  forward_zones    = var.forward_zones
  enable_unbound   = var.enable_unbound
  identifier_tags  = var.identifier_tags
}

module "dhcp_options" {
  source              = "../aws_dhcp_options"
  vpc_id              = var.vpc_id
  environment         = var.environment
  domain_name_servers = module.unbound.eni_ips
  update_dhcp_options = var.enable_unbound
  identifier_tags     = var.identifier_tags
}

module "bastion" {
  source              = "../aws_vpc_bastion"
  vpc_id              = var.vpc_id
  user                = var.user
  cluster_name        = "${var.user}-${var.environment}-${var.region}"
  environment         = var.environment
  num_az              = var.num_az
  available_az        = var.available_az
  public_subnets      = module.nat_subnets_setup.subnets["id"]
  services_subnets    = module.services_subnets_setup.subnets["id"]
  identifier_tags     = var.identifier_tags
  base_route53_domain = module.vpc_dns.zone_name
  route53_zone_id     = module.vpc_dns.zone_id
  enable_bastion      = var.enable_bastion
}

module "s3_vpc_endpoint" {
  source              = "../aws_vpc_endpoint"
  enable_vpc_endpoint = var.enable_s3_vpc_endpoint
  vpc_id              = var.vpc_id
  service             = "com.amazonaws.${var.region}.s3"
}

module "dynamodb_vpc_endpoint" {
  source              = "../aws_vpc_endpoint"
  enable_vpc_endpoint = var.enable_dynamodb_vpc_endpoint
  vpc_id              = var.vpc_id
  service             = "com.amazonaws.${var.region}.dynamodb"
}
