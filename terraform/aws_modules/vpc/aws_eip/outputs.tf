output "eip_alloc_id" {
  value = aws_eip.main.*.id
  description = "The ID of the EIPs"
}

