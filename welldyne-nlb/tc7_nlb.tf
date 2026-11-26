resource "aws_lb" "wd_nlb" {
  for_each = {
    for nlb in var.nlbs : nlb.name => nlb
  }
  name                             = each.value.name
  load_balancer_type               = local.nlb_load_balancer_type
  internal                         = each.value.nlb_internal
  ip_address_type                  = var.nlb_ip_address_type
  enable_cross_zone_load_balancing = var.nlb_enable_cross_zone_load_balancing
  enable_deletion_protection       = local.enable_deletion_protection
  tags                             = merge(var.prov_tags,
      {
        name                       = "${var.prov_tags["name"]}-nlb"
      }
  )
 
  dynamic "subnet_mapping" {
    for_each                = each.value.subnet_mappings
    content {
      subnet_id             = subnet_mapping.value.subnet_id    # The subnet to be attached
      allocation_id         = try(subnet_mapping.value.allocation_id, null)  # Public IP allocation ID for the subnet (if applicable)
      private_ipv4_address  = try(subnet_mapping.value.private_ipv4_address, null)   # Private IPv4 address for the subnet (if applicable)
    }
  }
}
 
resource "aws_lb_target_group" "wd_nlb_tg" {
  for_each = {
    for tg in var.nlb_target_groups : tg.name => tg
  }
  name                                = each.value.name
  vpc_id                              = var.vpc_id
  port                                = each.value.port
  protocol                            = each.value.protocol
  target_type                         = each.value.target_type
 
  health_check {
    protocol                          = each.value.health_check_protocol
    port                              = each.value.health_check_port
  }
  tags = merge(
    var.prov_tags,
    {
      Name                            = "${each.value.name}-tg"
    }
  )
}
 
 
resource "aws_lb_listener" "wd_nlb_listener" {
  for_each         = {
    for listener in var.nlb_listeners : listener.name => listener
  }
  region            = var.wd_region[var.prov_region]
  load_balancer_arn = local.nlb_arns[each.value.nlb_name]
  port              = each.value.port
  protocol          = each.value.protocol
 
  default_action {
    type             = "forward"
    forward {
      dynamic "target_group" {
        for_each       = each.value.target_group_names
        content {
          arn          = local.target_group_arns[target_group.value]
          #arn          = aws_lb_target_group.wd_nlb_tg[target_group.value].arn
          weight       = local.target_groups_weight[target_group.value]
        }
      }
    }
  }
 
  tags                                = merge(
    var.prov_tags,
    {
      Name                            = "${each.value.name}-listener"
    }
  )
}
 
resource "aws_lb_target_group_attachment" "wd_nlb_tg_attachment" {
  for_each         = {
    for attachment in var.nlb_target_group_attachments : "${attachment.target_group_name}-${attachment.target_id}" => attachment
  }
  target_group_arn = local.target_group_arns[each.value.target_group_name]
  target_id        = each.value.target_id
  port             = each.value.target_port
}
 