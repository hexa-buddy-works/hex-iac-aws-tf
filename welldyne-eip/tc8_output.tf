output "eip_details" {
  value = {
    for k, v in aws_eip.wd_eip :
    k => {
      id = v.id
      public_ip = v.public_ip
      allocation_id = v.allocation_id
      arn = v.arn
    }
  }
}

output "allocation_ids" {
  value = {
    for k, v in aws_eip.wd_eip :
    k => v.id
  }
}

output "public_ips" {
  value = {
    for k, v in aws_eip.wd_eip :
    k => v.public_ip
  }
}