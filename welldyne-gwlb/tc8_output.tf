output "gwlb_arn" {
  description = "ARN of the Gateway Load Balancer."
  value       = aws_lb.wd_gwlb.arn
}

output "gwlb_target_group_arn" {
  description = "Register your appliances in this target group."
  value       = aws_lb_target_group.wd_gwlb_tg.arn
}

output "gwlb_endpoint_service_name" {
  description = "Give this to the welldyne-gwlbe folder as gwlb_service_name."
  value       = aws_vpc_endpoint_service.wd_gwlb_service.service_name
}