resource "aws_vpc" "wd_vpc" {
  count = var.vpc_count
  cidr_block                           = var.vpcs[count.index].cidr_block
  instance_tenancy                     = var.vpcs[count.index].instance_tenancy
  enable_dns_hostnames                 = local.enable_dns_hostnames
  enable_dns_support                   = local.enable_dns_support
  enable_network_address_usage_metrics = var.vpcs[count.index].enable_network_address_usage_metrics
  region                               = var.wd_region[var.prov_region]
  tags                                 = var.prov_tags

  lifecycle {
    prevent_destroy                    = true
    #Ensure the CIDR block within Class A range
    precondition {
      condition                        = can(regex("^10\\.", var.vpcs[count.index].cidr_block))
      error_message                    = "The VPC CIDR block must reside within the Class A (10.0.0.0/16) private IP range"
    }
  }
}