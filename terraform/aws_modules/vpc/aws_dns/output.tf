output "zone_name" {
  description = "The name of the zone"
  value = "${var.subdomain}.${var.base_dns}"
}

output "zone_id" {
  description = "The ID of the zone"
  value = aws_route53_zone.main[0].zone_id
}

