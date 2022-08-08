output "id" {
  description = "The VPC ID"
  value = aws_vpc.main.id
}

output "cidr_block" {
  description = "The CIDR block of the VPC"
  value = aws_vpc.main.cidr_block
}

