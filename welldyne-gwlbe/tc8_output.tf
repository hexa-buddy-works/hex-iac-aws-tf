output "gwlbe_id" {
  description = "IDs of the GWLB endpoints in the same order as var.gwlbes."
  value       = aws_vpc_endpoint.wd_gwlbe[*].id
}

output "gwlbe_map" {
  description = "Map of GWLB endpoint name to endpoint ID."

  value = {
    for idx, endpoint in aws_vpc_endpoint.wd_gwlbe :
    var.gwlbes[idx].name => endpoint.id
  }
}

output "gwlbe_details" {
  description = "GWLB endpoint details in the same order as var.gwlbes."

  value = [
    for idx, endpoint in aws_vpc_endpoint.wd_gwlbe : {
      name         = var.gwlbes[idx].name
      id           = endpoint.id
      arn          = endpoint.arn
      subnet_id    = var.gwlbes[idx].subnet_id
      service_name = endpoint.service_name
    }
  ]
}