locals {
  vgw_name = "${var.environment}-${var.application}-vgw"
}

resource "aws_vpn_gateway" "main" {
  vpc_id = var.vpc_id
  tags = merge(
    {
      "Name" = format("%s", local.vgw_name)
    },
    var.tags,
  )
}

