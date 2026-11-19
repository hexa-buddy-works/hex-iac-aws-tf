output "vpc_id" {
  description = "VPC ID from scenario 1"
  value       = try(aws_vpc.my_vpc.id, try(aws_vpc.main.id, null))
}

output "private_subnet_ids" {
  description = "Private subnet IDs from scenarios 2, 3, 10, and 9"
  value = concat(
    try(aws_subnet.private_subnet[*].id, []),
    try(aws_subnet.multi_az_subnet[*].id, []),
    try(aws_subnet.private[*].id, []),                  # for scenario 9 and 10
    try(aws_subnet.private_app[*].id, []),
    try(aws_subnet.private_one_az[*].id, []),
    try(aws_subnet.private_multi_az2[*].id, []),
    try(aws_subnet.private_3azs[*].id, [])
  )
}

output "public_subnet_ids" {
  description = "Public subnet IDs from scenarios 4, 5, 8"
  value = concat(
    try(aws_subnet.public[*].id, []),
    try(aws_subnet.nlb_public_1.id != null ? [aws_subnet.nlb_public_1.id] : [], []),
    try(aws_subnet.nlb_public_2.id != null ? [aws_subnet.nlb_public_2.id] : [], []),
    try(aws_subnet.nlb_public_3.id != null ? [aws_subnet.nlb_public_3.id] : [], [])
  )
}

output "multi_az_private_subnet_ids" {
  description = "Scenario 3: Private subnets in multiple AZs"
  value       = try(aws_subnet.multi_az_subnet[*].id, [])
}

output "single_private_subnet_id" {
  description = "Scenario 2: Single private subnet"
  value       = try(aws_subnet.private_subnet[*].id, [])
}

output "inspection_subnet_ids" {
  description = "Inspection subnet IDs for GWLB"
  value       = try(aws_subnet.inspection[*].id, [])
}

output "transit_gateway_id" {
  description = "Transit Gateway ID (scenario 6)"
  value       = try(aws_ec2_transit_gateway.main.id, null)
}

output "transit_gateway_attachment_id" {
  description = "Transit Gateway VPC attachment ID (scenario 6)"
  value       = try(aws_ec2_transit_gateway_vpc_attachment.main.id, null)
}

output "nlb_dns_name" {
  description = "DNS name for the NLB (scenario 8)"
  value       = try(aws_lb.public_nlb.dns_name, null)
}

output "gwlb_dns_name" {
  description = "DNS name for the GWLB (scenario 7)"
  value       = try(aws_lb.gwlb.dns_name, null)
}

output "route_table_ids" {
  description = "IDs of all route tables"
  value = concat(
    try([aws_route_table.public.id], []),
    try([aws_route_table.private.id], []),
    try([aws_route_table.public_app.id], []),
    try([aws_route_table.private_app.id], [])
  )
}