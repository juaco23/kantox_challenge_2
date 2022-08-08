# module: aws_vpc_endpoint
resource "aws_vpc_endpoint" "vpc_endpoint" {
  count        = var.enable_vpc_endpoint
  vpc_id       = var.vpc_id
  service_name = var.service

  security_group_ids = [
    var.aws_security_group_id,
  ]

  private_dns_enabled = var.private_dns_enabled
}

