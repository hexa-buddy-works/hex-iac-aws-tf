output "nlb_arn" {
  description = "ARN of the Network Load Balancer."
  value       = aws_lb.wd_nlb.arn
}

output "nlb_dns_name" {
  description = "DNS name of the Network Load Balancer."
  value       = aws_lb.wd_nlb.dns_name
}

output "nlb_target_group_arn" {
  description = "Register your servers in this target group."
  value       = aws_lb_target_group.wd_nlb_tg.arn
}