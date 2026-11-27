resource "aws_subnet" "wd_subnet" {
  count                   = local.effective_subnet_count
  vpc_id                  = var.vpc_id
  region                  = var.wd_region[var.prov_region]
  map_public_ip_on_launch = var.subnet_type[var.prov_subnet_type]
  availability_zone       = var.same_az_subnets ? var.availability_zone : local.azs_status ? local.azs[count.index] : "null"
  enable_dns64            = var.enable_dns64
  cidr_block              = var.cidr_blocks != null ? var.cidr_blocks[count.index] : cidrsubnet(
            var.vpc_cidr_block, try(var.subnet_newbits_list[count.index], 
            var.subnet_newbits), count.index)
  
  tags                    = merge(var.prov_tags,
    {
      name = "${var.prov_tags["name"]}-${count.index + 1}"
  })
}