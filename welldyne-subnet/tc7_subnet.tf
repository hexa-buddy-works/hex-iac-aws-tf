resource "aws_subnet" "wd_subnet" {
  vpc_id                                      = var.vpc_id
  region                                      = var.wd_region[var.prov_region]
  cidr_block                                  = var.cidr_block
  map_public_ip_on_launch                     = var.subnet_type[var.prov_subnet_type]
  availability_zone                           = var.availability_zone
  enable_dns64                                = var.enable_dns64
  tags                                        = var.prov_tags
}