output "route_table_ids" {
  description = "Route table IDs"
  value = {
    for k, v in aws_route_table.wd_route_table :
    k => v.id
  }
}

output "route_table_arns" {
  description = "Route table ARNs"
  value = {
    for k, v in aws_route_table.wd_route_table :
    k => v.arn
  }
}