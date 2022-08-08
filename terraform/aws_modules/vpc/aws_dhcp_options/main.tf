## module: aws_dhcp_options

data "aws_region" "current" {
  current = true
}


locals {
  dhcp_option_tags = {
    inputs = {
      Environment = data.aws_region.current.name
      Name        = "${var.environment} - ${data.aws_region.current.name}"
      Region      = data.aws_region.current.name
    }
  }
}

resource "aws_vpc_dhcp_options" "main" {
  count = var.update_dhcp_options
  domain_name = lookup(
    var.domain_names,
    data.aws_region.current.name,
    "${data.aws_region.current.name}.compute.internal",
  )
  domain_name_servers = var.domain_name_servers
  tags = merge(
    var.identifier_tags,
    local.dhcp_option_tags.inputs,
  )
}

resource "aws_vpc_dhcp_options_association" "main" {
  count           = var.update_dhcp_options
  dhcp_options_id = aws_vpc_dhcp_options.main[0].id
  vpc_id          = var.vpc_id
}

