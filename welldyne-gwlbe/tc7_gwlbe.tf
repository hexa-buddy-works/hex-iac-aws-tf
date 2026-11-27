# One GWLB endpoint per entry in var.gwlbes.
# Each GWLBE lives in a single subnet / AZ and attaches to one GWLB endpoint service,
# selected by gwlb_index from the list exported by the welldyne-gwlb module.


resource "aws_vpc_endpoint" "wd_gwlbe" {
  count = length(var.gwlbes)
  vpc_id = var.vpc_id
  service_name = try(var.gwlb_endpoint_service_name[var.gwlbes[count.index].gwlb_index],"")

  vpc_endpoint_type = "GatewayLoadBalancer"
  subnet_ids        = [var.gwlbes[count.index].subnet_id]

  tags = merge(
    var.prov_tags,
    {
      Name = "${var.gwlbes[count.index].name}-gwlbe"
    }
  )

  lifecycle {
    precondition {
      condition     = var.gwlbe_count == length(var.gwlbes)
      error_message = "gwlbe_count must match the number of entries in gwlbes."
    }

    precondition {
      condition = (
        var.gwlbes[count.index].gwlb_index >= 0 &&
        var.gwlbes[count.index].gwlb_index < length(var.gwlb_endpoint_service_name)
      )
      error_message = "The gwlb_index for ${var.gwlbes[count.index].name} is outside the available GWLB service-name list."
    }
  }
}