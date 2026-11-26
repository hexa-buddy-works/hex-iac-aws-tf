resource "aws_vpc" "wd_vpc" {
  cidr_block                           = var.cidr_block
  instance_tenancy                     = var.instance_tenancy
  enable_dns_support                   = var.enable_dns_support
  enable_dns_hostnames                 = var.enable_dns_hostnames
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics
  region                               = var.wd_region[var.prov_region]
  tags                                 = var.prov_tags
}