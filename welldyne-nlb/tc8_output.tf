output "nlb_arns" {
  description = "ARNs of the Network Load Balancers."
  value       = aws_lb.wd_nlb[*].arn
}

output "nlb_names" {
  description = "Names of the Network Load Balancers."
  value       = aws_lb.wd_nlb[*].name
}

output "nlb_cross_zone_status" {
  description = "Cross-zone load balancing status of the Network Load Balancers."
  value       = aws_lb.wd_nlb[*].enable_cross_zone_load_balancing
}

output "nlb_regions" {
  description = "Regions of the Network Load Balancers."
  value       = aws_lb.wd_nlb[*].region
}

output "nlb_target_group_arns" {
  description = "Register your servers in this target group."
  value       = aws_lb_target_group.wd_nlb_tg[*].arn
}

output "nlb_subnet_mappings" {
  description = "Subnet mappings of the Network Load Balancers."
  value       = aws_lb.wd_nlb[*].subnet_mapping
}