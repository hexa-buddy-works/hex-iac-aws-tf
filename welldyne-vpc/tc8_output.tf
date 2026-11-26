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

output "owner_id" {
  description = "Owner account IDs of all created VPCs."
  value       = aws_vpc.wd_vpc[*].owner_id
}

output "aws_main_route_table_id" {
  description = "Main route table IDs of all created VPCs."
  value       = aws_vpc.wd_vpc[*].main_route_table_id
}

output "region" {
  description = "Regions of all created VPCs."
  value       = aws_vpc.wd_vpc[*].region
}

output "default_network_acl_id" {
  description = "Default network ACL IDs."
  value       = aws_vpc.wd_vpc[*].default_network_acl_id
}

output "default_route_table_id" {
  description = "Default route table IDs."
  value       = aws_vpc.wd_vpc[*].default_route_table_id
}

output "default_security_group_id" {
  description = "Default security group IDs."
  value       = aws_vpc.wd_vpc[*].default_security_group_id
}

output "default_dhcp_options_id" {
  description = "Default DHCP option set IDs."
  value       = aws_vpc.wd_vpc[*].dhcp_options_id
}

output "instance_tenancy" {
  description = "Instance tenancy values."
  value       = aws_vpc.wd_vpc[*].instance_tenancy
}

output "enable_dns_support" {
  description = "DNS support settings."
  value       = aws_vpc.wd_vpc[*].enable_dns_support
}

output "enable_dns_hostnames" {
  description = "DNS hostname settings."
  value       = aws_vpc.wd_vpc[*].enable_dns_hostnames
}

output "enable_network_address_usage_metrics" {
  description = "Network address usage metrics settings."
  value       = aws_vpc.wd_vpc[*].enable_network_address_usage_metrics
}

output "vpc_tags" {
  description = "Tags applied to all created VPCs."
  value       = aws_vpc.wd_vpc[*].tags_all
}