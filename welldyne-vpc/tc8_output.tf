output "vpc_id" {
  value = aws_vpc.wd_vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.wd_vpc.cidr_block
}

output "vpc_arn" {
  value = aws_vpc.wd_vpc.arn
}

output "owner_id" {
  value = aws_vpc.wd_vpc.owner_id
}

output "aws_main_route_table_id" {
  value = aws_vpc.wd_vpc.main_route_table_id
}

output "region" {
  value = aws_vpc.wd_vpc.region
}