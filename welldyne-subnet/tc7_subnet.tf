resource "aws_subnet" "wd_subnet" {
  vpc_id = var.vpc_id
  region = var.wd_region[var.prov_region]
  cidr_block              = var.subnet_types[var.subnet_type].cidr_block
  map_public_ip_on_launch = var.subnet_types[var.subnet_type].map_public_ip_on_launch
  availability_zone                           = var.availability_zone
  customer_owned_ipv4_pool                    = var.customer_owned_ipv4_pool
  enable_dns64                                = var.enable_dns64
  enable_lni_at_device_index                  = var.enable_lni_at_device_index
  enable_resource_name_dns_a_record_on_launch = var.enable_resource_name_dns_a_record_on_launch
  ipv4_ipam_pool_id                           = var.ipv4_ipam_pool_id
  ipv4_netmask_length                         = var.ipv4_netmask_length
  map_customer_owned_ip_on_launch             = var.map_customer_owned_ip_on_launch
  private_dns_hostname_type_on_launch         = var.private_dns_hostname_type_on_launch

  tags = var.tags
}