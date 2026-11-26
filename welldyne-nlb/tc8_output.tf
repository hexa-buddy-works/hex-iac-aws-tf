output "nlb_arns" {
  description = "Network Load Balancer ARNs"
  value = {
    for name, nlb in aws_lb.wd_nlb :
    name => nlb.arn
  }
}

output "nlb_names" {
  description = "Network Load Balancer Name"
  value = {
    for name, nlb in aws_lb.wd_nlb :
    name => nlb.name
  }
}

output "nlb_target_groups_arn" {
  description = "Network Load Balancer Target Groups ARNs"
  value = {
    for name, tg in aws_lb_target_group.wd_nlb_tg :
    name => tg.arn
  }
}

output "nlb_listener_arn" {
  description = "Network Load Balancer Listener ARNs"
  value = {
    for name, listener in aws_lb_listener.wd_nlb_listener :
    name => listener.arn
  }
}