output "gwlb_arn" {
  description = "ARNs of the Gateway Load Balancers."
  value       = aws_lb.wd_gwlb[*].arn
}

output "gwlb_target_group_arn" {
  description = "Target Group ARNs."
  value       = aws_lb_target_group.wd_gwlb_tg[*].arn
}

output "gwlb_endpoint_service_name" {
  description = "Endpoint Service Names."
  value       = aws_vpc_endpoint_service.wd_gwlb_service[*].service_name
}