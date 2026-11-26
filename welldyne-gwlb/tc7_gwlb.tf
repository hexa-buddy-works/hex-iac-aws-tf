resource "aws_lb" "wd_gwlb" {
  count                            = var.gwlb_count
  name                             = var.gwlbs[count.index].name 
  region                           = var.wd_region[var.prov_region]
  load_balancer_type               = "gateway"
  enable_cross_zone_load_balancing = var.gwlb_enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection

  dynamic "subnet_mapping" {
    for_each = var.gwlbs[count.index].subnet_mappings

    content {
      subnet_id = subnet_mapping.value.subnet_id //AVAILABILITY ID , PRIVATE IPV4 ADDRESS
    }
  }
  tags = merge(var.prov_tags,
    {
      name = "${var.gwlbs[count.index].name}-gwlb"
    }
  )
}

# GWLB always talks to its appliances using GENEVE on port 6081
resource "aws_lb_target_group" "wd_gwlb_tg" {
  count       = length(var.gwlb_target_groups)
  name        = var.gwlb_target_groups[count.index].name
  region      = var.wd_region[var.prov_region]
  vpc_id      = var.vpc_id
  port        = 6081
  protocol    = "GENEVE"
  target_type = var.gwlb_target_groups[count.index].target_type

  health_check {
    protocol = "TCP"
    port     = var.gwlb_target_groups[count.index].health_check_port
  }

  tags = merge(var.prov_tags,
    {
      name = var.gwlb_target_groups[count.index].name
    }
  )
}

# A GWLB listener has no port or protocol, it forwards all traffic

resource "aws_lb_listener" "wd_gwlb_listener" {
  count             = var.gwlb_count
  region            = var.wd_region[var.prov_region]
  load_balancer_arn = aws_lb.wd_gwlb[count.index].arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wd_gwlb_tg[count.index].arn
  }
}

# Publishes the GWLB so that endpoints (GWLBE) can connect to it
resource "aws_vpc_endpoint_service" "wd_gwlb_service" {
  count                      = var.gwlb_count
  region                     = var.wd_region[var.prov_region]
  acceptance_required        = var.gwlb_service_acceptance_required
  gateway_load_balancer_arns = [aws_lb.wd_gwlb[count.index].arn]
  tags = merge(var.prov_tags,
    {
      name = "${var.gwlbs[count.index].name}-service"
    }
  )
}