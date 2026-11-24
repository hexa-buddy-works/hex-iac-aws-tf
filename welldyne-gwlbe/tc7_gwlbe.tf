
resource "aws_vpc_endpoint" "wd_gwlbe" {
  region            = var.wd_region[var.prov_region]
  vpc_id            = var.vpc_id
  service_name      = var.gwlb_service_name
  vpc_endpoint_type = "GatewayLoadBalancer"
  subnet_ids        = var.gwlbe_subnet_ids
  tags = merge(var.prov_tags,
    {
      name = "${var.prov_tags["name"]}-gwlbe"
    }
  )
}

