locals {
  route_entries = merge([
    for rt_name, rt in var.route_tables :
    {
      for route_name, route in rt.routes :
      "${rt_name}-${route_name}" => {
        route_table_name = rt_name
        destination_cidr_block = route.destination_cidr_block
        gateway_id = try(route.gateway_id, null)
        nat_gateway_id = try(route.nat_gateway_id, null)
        transit_gateway_id = try(route.transit_gateway_id, null)
        vpc_endpoint_id = try(route.vpc_endpoint_id, null)
      }
    }
  ]...)
}

locals {
  subnet_associations = merge([
    for rt_name, rt in var.route_tables :
    {
      for idx, subnet_id in rt.subnet_ids :
      "${rt_name}-${idx}" => {
        route_table_name = rt_name
        subnet_id        = subnet_id
      }
    }
  ]...)
}

resource "aws_route_table" "wd_route_table" {
#  region = var.wd_region[var.prov_region]

  for_each = var.route_tables
  vpc_id = var.vpc_id
  tags = merge(
    var.prov_tags,
    {
      Name = each.key
    }
  )
}

# One aws_route per entry in the routes map
resource "aws_route" "wd_route" {
  for_each = local.route_entries

  route_table_id         = aws_route_table.wd_route_table[each.value.route_table_name].id
#  region                 = var.wd_region[var.prov_region]
  destination_cidr_block = each.value.destination_cidr_block
  gateway_id             = each.value.gateway_id
  nat_gateway_id         = each.value.nat_gateway_id
  vpc_endpoint_id        = each.value.vpc_endpoint_id
  transit_gateway_id     = each.value.transit_gateway_id
}

# Attaches the route table to every subnet in the list
resource "aws_route_table_association" "wd_rt_association" {
  #count = length(var.subnet_ids)
  for_each = local.subnet_associations

  route_table_id = aws_route_table.wd_route_table[each.value.route_table_name].id
#  region         = var.wd_region[var.prov_region]
  subnet_id      = each.value.subnet_id
}