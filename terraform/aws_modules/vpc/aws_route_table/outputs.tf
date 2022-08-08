// module: aws_route_table

output "route_table_ids" {
  description = "The ID of the route tables"
  value = aws_route_table.main.*.id
}

