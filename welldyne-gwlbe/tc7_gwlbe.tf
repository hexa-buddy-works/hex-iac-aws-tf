# One GWLB endpoint per entry in var.gwlbes.
# Each GWLBE lives in a single subnet / AZ and attaches to one GWLB endpoint service,
# selected by gwlb_index from the list exported by the welldyne-gwlb module.


resource "aws_vpc_endpoint" "wd_gwlbe" {
  count             = var.gwlbe_count
  region            = var.wd_region[var.prov_region]
  vpc_id            = var.vpc_id
  service_name      = var.gwlb_endpoint_service_name[var.gwlbes[count.index].gwlb_index]
  vpc_endpoint_type = "GatewayLoadBalancer"
  subnet_ids        = [var.gwlbes[count.index].subnet_id]

  tags = merge(var.prov_tags,
    {
      name = "${var.gwlbes[count.index].name}-gwlbe"
    }
  )
}