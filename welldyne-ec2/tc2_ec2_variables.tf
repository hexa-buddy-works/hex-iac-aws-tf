variable "region" { type = string }
variable "profile" { type = string }
variable "ami" { type = string }
variable "instance_type" { type = string }
variable "availability_zone" { type = string }
variable "user_data" { type = string }
variable "key_name" { type = string }
variable "subnet_id" { type = string }
variable "associate_public_ip_address" { type = bool }
variable "private_ip" { type = string }
variable "ipv6_address_count" { type = number }
variable "ipv6_addresses" { type = list(string) }
variable "vpc_security_group_ids" { type = list(string) }
variable "monitoring" { type = bool }
variable "tenancy" { type = string }
variable "ebs_optimized" { type = bool }
variable "disable_api_termination" { type = bool }
variable "instance_initiated_shutdown_behavior" { type = string }
variable "source_dest_check" { type = bool }
variable "hibernation" { type = bool }

variable "cpu_threads_per_core" { type = number }
variable "get_password_data" { type = bool }
variable "cpu_credits" { type = string }
variable "capacity_reservation_preference" { type = string }
variable "enclave_enabled" { type = bool }
variable "auto_recovery" { type = string }
variable "http_endpoint" { type = string }
variable "http_tokens" { type = string }
variable "http_put_response_hop_limit" { type = number }
variable "instance_metadata_tags" { type = string }
variable "placement_group" { type = string }
variable "host_id" { type = string }
variable "root_volume_type" { type = string }
variable "root_volume_size" { type = number }
variable "root_iops" { type = number }
variable "root_throughput" { type = number }
variable "root_delete_on_termination" { type = bool }
variable "root_encrypted" { type = bool }
variable "root_kms_key_id" { type = string }
variable "root_tags" { type = map(string) }
variable "cpu_core_count" { type = number }

variable "ebs_block_devices" {
  type = list(object({
    device_name           = string
    volume_type           = string
    volume_size           = number
    iops                  = number
    throughput            = number
    delete_on_termination = bool
    encrypted             = bool
    kms_key_id            = string
    snapshot_id           = string
    tags                  = map(string)
  }))
}

variable "network_interfaces" {
  type = list(object({
    device_index         = number
    network_interface_id = string
  }))
}

variable "tags" { type = map(string) }