output "instance_ids" {
  value = aws_instance.wd_ec2[*].id
}

output "private_ips" {
  value = aws_instance.wd_ec2[*].private_ip
}

output "public_ips" {
  value = aws_instance.wd_ec2[*].public_ip
}

output "instance_arns" {
  value = aws_instance.wd_ec2[*].arn
}