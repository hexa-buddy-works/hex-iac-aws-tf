output "vpc_id" {
  description = "IDs of all created VPCs."
  value       = aws_vpc.wd_vpc[*].id
}

output "vpc_cidr_block" {
  description = "CIDR blocks of all created VPCs."
  value       = aws_vpc.wd_vpc[*].cidr_block
}

output "vpc_arn" {
  description = "ARNs of all created VPCs."
  value       = aws_vpc.wd_vpc[*].arn
}

output "region" {
  description = "Regions of all created VPCs."
  value       = aws_vpc.wd_vpc[*].region
}

output "instance_tenancy" {
  description = "Instance tenancy values."
  value       = aws_vpc.wd_vpc[*].instance_tenancy
}

output "enable_dns_support" {
  description = "DNS support settings."
  value       = aws_vpc.wd_vpc[*].enable_dns_support
}
