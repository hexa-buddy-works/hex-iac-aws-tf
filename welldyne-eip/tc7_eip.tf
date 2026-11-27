resource "aws_eip" "wd_eip" {
  for_each = var.eips
  domain = each.value.domain

  tags = merge(
    var.prov_tags,
    each.value.tags,
    {
      Name = each.key
    }
  )
}