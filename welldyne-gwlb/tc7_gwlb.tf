resource "aws_lb" "wd_gwlb" {
  name                             = var.gwlb_name
  region                           = var.wd_region[var.prov_region]
  load_balancer_type               = "gateway"
  subnets                          = var.gwlb_subnet_ids
  enable_cross_zone_load_balancing = var.gwlb_enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection
  tags = merge(var.prov_tags,
    {
      name = "${var.prov_tags["name"]}-gwlb"
    }
  )
}

# GWLB always talks to its appliances using GENEVE on port 6081
resource "aws_lb_target_group" "wd_gwlb_tg" {
  name        = "${var.gwlb_name}-tg"
  region      = var.wd_region[var.prov_region]
  vpc_id      = var.vpc_id
  port        = 6081
  protocol    = "GENEVE"
  target_type = var.gwlb_target_type

  health_check {
    protocol = "TCP"
    port     = var.gwlb_health_check_port
  }

  tags = merge(var.prov_tags,
    {
      name = "${var.prov_tags["name"]}-gwlb-tg"
    }
  )
}

# A GWLB listener has no port or protocol, it forwards all traffic
resource "aws_lb_listener" "wd_gwlb_listener" {
  region            = var.wd_region[var.prov_region]
  load_balancer_arn = aws_lb.wd_gwlb.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wd_gwlb_tg.arn
  }
}

# Publishes the GWLB so that endpoints (GWLBE) can connect to it
resource "aws_vpc_endpoint_service" "wd_gwlb_service" {
  region                     = var.wd_region[var.prov_region]
  acceptance_required        = var.gwlb_service_acceptance_required
  gateway_load_balancer_arns = [aws_lb.wd_gwlb.arn]
  tags = merge(var.prov_tags,
    {
      name = "${var.prov_tags["name"]}-gwlb-service"
    }
  )
}