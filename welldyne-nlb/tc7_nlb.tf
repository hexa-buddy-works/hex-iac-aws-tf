resource "aws_lb" "wd_nlb" {
  name                             = var.nlb_name
  region                           = var.wd_region[var.prov_region]
  load_balancer_type               = "network"
  internal                         = var.nlb_internal
  subnets                          = var.nlb_subnet_ids
  ip_address_type                  = var.nlb_ip_address_type
  enable_cross_zone_load_balancing = var.nlb_enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection
  tags = merge(var.prov_tags,
    {
      name = "${var.prov_tags["name"]}-nlb"
    }
  )
}

resource "aws_lb_target_group" "wd_nlb_tg" {
  name        = "${var.nlb_name}-tg"
  region      = var.wd_region[var.prov_region]
  vpc_id      = var.vpc_id
  port        = var.nlb_target_port
  protocol    = "TCP"
  target_type = var.nlb_target_type

  health_check {
    protocol = "TCP"
  }

  tags = merge(var.prov_tags,
    {
      name = "${var.prov_tags["name"]}-nlb-tg"
    }
  )
}

resource "aws_lb_listener" "wd_nlb_listener" {
  region            = var.wd_region[var.prov_region]
  load_balancer_arn = aws_lb.wd_nlb.arn
  port              = var.nlb_listener_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wd_nlb_tg.arn
  }
}