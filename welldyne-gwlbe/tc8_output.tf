output "gwlbe_id" {
  description = "IDs of the GWLB endpoints, in the same order as var.gwlbes."
  value       = aws_vpc_endpoint.wd_gwlbe[*].id
}

output "gwlbe_map" {
  description = "Map of GWLBE name => endpoint ID, for use in route tables."
  value = {
    for idx, ep in aws_vpc_endpoint.wd_gwlbe :
    var.gwlbes[idx].name => ep.id
  }
}