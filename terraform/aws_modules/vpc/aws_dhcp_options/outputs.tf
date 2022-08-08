// module: vpc_dhcp_options

output "id" {
  description = "The DHCP options ID"
  depends_on = [aws_vpc_dhcp_options_association.main]
  value      = aws_vpc_dhcp_options.main[0].id
}

