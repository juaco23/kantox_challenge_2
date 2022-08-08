locals {
  cgw_name = "${var.environment}-${var.application}-cgw"
}

resource "aws_customer_gateway" "main" {
  bgp_asn    = var.bgp_asn
  ip_address = var.cgw_ip_address
  type       = "ipsec.1"

  tags = merge(
    {
      "Name" = format("%s", local.cgw_name)
    },
    var.tags,
  )
}

