## module: vpc_subnet_public

output "subnet_ids" {
  description = "The ID of the subnets"
  value = aws_subnet.main.*.id
}

output "subnet_cidrs" {
  description = "The CIDRs of the subnet"
  value = aws_subnet.main.*.cidr_block
}

output "subnets" {
  description = "A mapping of subnet properties (ID, Availability zone, CIDR blocks)"
  value = {
    id = [
      aws_subnet.main.*.id,
    ]
    availability_zone = [
      aws_subnet.main.*.availability_zone,
    ]
    cidr_block = [
      aws_subnet.main.*.cidr_block,
    ]
  }
}

