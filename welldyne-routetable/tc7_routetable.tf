
resource "aws_route_table" "wd_route_table" {
  vpc_id = var.vpc_id
  region = var.wd_region[var.prov_region]
  tags   = var.prov_tags
}

# One aws_route per entry in the routes map
resource "aws_route" "wd_route" {
  for_each = var.routes

  route_table_id         = aws_route_table.wd_route_table.id
  region                 = var.wd_region[var.prov_region]
  destination_cidr_block = each.value.destination_cidr_block
  gateway_id             = each.value.gateway_id
  nat_gateway_id         = each.value.nat_gateway_id
  vpc_endpoint_id        = each.value.vpc_endpoint_id
  transit_gateway_id     = each.value.transit_gateway_id
}

# Attaches the route table to every subnet in the list
resource "aws_route_table_association" "wd_rt_association" {
  count = length(var.subnet_ids)

  route_table_id = aws_route_table.wd_route_table.id
  region         = var.wd_region[var.prov_region]
  subnet_id      = var.subnet_ids[count.index]
}