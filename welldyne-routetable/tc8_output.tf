output "route_table_id" {
  description = "ID of the route table."
  value       = aws_route_table.wd_route_table.id
}

output "route_table_arn" {
  description = "ARN of the route table."
  value       = aws_route_table.wd_route_table.arn
}