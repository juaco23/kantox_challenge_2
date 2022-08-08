
locals {
  dns_tags = {
    inputs = {
      Environment = var.environment
      Name        = "${var.subdomain} - ${var.region}"
      Region      = var.region
    }
  }
}

resource "aws_route53_zone" "main" {
  count = var.enable_dns
  name  = "${var.subdomain}.${var.base_dns}"

  tags = merge(var.identifier_tags, local.dns_tags.inputs)
}

resource "aws_route53_record" "main" {
  count   = var.enable_dns
  name    = "${var.subdomain}.${var.base_dns}"
  zone_id = var.parent_zone

  ttl  = "30"
  type = "NS"

  records = [
    aws_route53_zone.main[0].name_servers[0],
    aws_route53_zone.main[0].name_servers[1],
    aws_route53_zone.main[0].name_servers[2],
    aws_route53_zone.main[0].name_servers[3],
  ]
}

