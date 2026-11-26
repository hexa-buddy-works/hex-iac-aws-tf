resource "aws_vpc" "wd_vpc" {
  count = var.vpc_count
  cidr_block                           = var.vpcs[count.index].cidr_block
  instance_tenancy                     = var.vpcs[count.index].instance_tenancy
  enable_dns_support                   = var.vpcs[count.index].enable_dns_support
  enable_dns_hostnames                 = var.vpcs[count.index].enable_dns_hostnames
  enable_network_address_usage_metrics = var.vpcs[count.index].enable_network_address_usage_metrics
  region                               = var.wd_region[var.prov_region]
  tags                                 = var.vpcs[count.index].prov_tags

  lifecycle {
    precondition {
      condition     = var.vpc_count == length(var.vpcs)
      error_message = "vpc_count must equal the number of objects supplied in vpcs."
    }
  }
}