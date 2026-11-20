output "subnet_id" {
  value = aws_subnet.wd_subnet[*].id
}

output "subnet_cidr_block" {
  value = [
    for subnet in aws_subnet.wd_subnet : subnet.cidr_block
  ]
}

output "subnet_az" {
  value = [
    for subnet in aws_subnet.wd_subnet : "${subnet.id} : ${subnet.availability_zone}"
  ]
}

output "subnet_arn" {
  value = aws_subnet.wd_subnet[*].arn
}

output "region" {
  value = aws_subnet.wd_subnet[*].region
}

output "subnet_tags" {
  value = [
    for subnet in aws_subnet.wd_subnet : subnet.tags
  ]
}

output "ipv4_netmask_length" {
  value = [
    for subnet in aws_subnet.wd_subnet : subnet.ipv4_netmask_length
  ]
}

output "outpost_arn" {
  value = aws_subnet.wd_subnet[*].outpost_arn
}