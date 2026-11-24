output "gwlbe_id" {
  description = "ID of the Gateway Load Balancer Endpoint. Use it as the target in route tables."
  value       = aws_vpc_endpoint.wd_gwlbe.id
}