resource "aws_lb" "wd_nlb" {
  count                            = var.nlb_count
  name                             = var.nlbs[count.index].name
  region                           = var.wd_region[var.prov_region]
  load_balancer_type               = var.nlbs[count.index].load_balancer_type
  internal                         = var.nlbs[count.index].nlb_internal
  ip_address_type                  = var.nlb_ip_address_type
  enable_cross_zone_load_balancing = var.nlb_enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection
  tags                             = merge(var.prov_tags,
      {
        name                       = "${var.prov_tags["name"]}-nlb"
      }
  )

  dynamic "subnet_mapping" {
    for_each                = var.nlbs[count.index].subnet_mappings
    content {
      subnet_id             = subnet_mapping.value.subnet_id    # The subnet to be attached
      allocation_id         = subnet_mapping.value.allocation_id == null ? null : subnet_mapping.value.allocation_id   # Public IP allocation ID for the subnet (if applicable)
      private_ipv4_address  = subnet_mapping.value.private_ipv4_address == null ? null : subnet_mapping.value.private_ipv4_address   # Private IPv4 address for the subnet (if applicable)
    }
  }
}

resource "aws_lb_target_group" "wd_nlb_tg" {
  count                               = length(var.nlb_target_groups)
  name                                = var.nlb_target_groups[count.index].name
  vpc_id                              = var.vpc_id
  port                                = var.nlb_target_groups[count.index].port
  protocol                            = var.nlb_target_groups[count.index].protocol
  target_type                         = var.nlb_target_groups[count.index].target_type

  health_check {
    protocol                          = var.nlb_target_groups[count.index].protocol
  }
  tags                                = merge(
    var.prov_tags,
    {
      Name                            = var.nlb_target_groups[count.index].name
    }
  )
}


# resource "aws_lb_listener" "wd_nlb_listener" {
#   count             = var.nlb_count
#   region            = var.wd_region[var.prov_region]
#   load_balancer_arn = aws_lb.wd_nlb[count.index].arn
#   port              = var.nlb_listener_port
#   protocol          = "TCP"

#   default_action {
#     type             = "forward"
#     dynamic "target_group" {
#       for_each = var.nlb_target_group_arns[count.index]
#       content {
#         arn = target_group.value["arn"]
#         weight = target_group.value["weight"]
#       }
#     }
#   }
# }

/*
resource "aws_lb_target_group_attachment" "wd_nlb_tg_ip" {
  count            = length(var.nlb_target_ips)
  target_group_arn = aws_lb_target_group.wd_nlb_tg.arn
  target_id        = var.nlb_target_ips[count.index]
  port             = var.nlb_target_port
}
resource "aws_lb_target_group_attachment" "wd_nlb_tg_instance" {
  count            = length(var.nlb_target_instance_ids)
  target_group_arn = aws_lb_target_group.wd_nlb_tg.arn
  target_id        = var.nlb_target_instance_ids[count.index]
  port             = var.nlb_target_port
}
The NLB identifies the target group based on the protocol and port.
The use case for this is BlueGreen/Canary/Incremental deployments where you want to send a percentage of traffic to a new version of the application.
The NLB can forward traffic to multiple target groups based on weights, allowing for gradual rollouts and testing of new versions without impacting the entire user base. 


resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.app_v1.arn
        weight = 90
      }

      target_group {
        arn    = aws_lb_target_group.app_v2.arn
        weight = 10
      }
    }
  }
}
*/