resource "aws_instance" "example" {
  ami                                  = var.ami
  instance_type                        = var.instance_type
  availability_zone                    = var.availability_zone
  user_data                            = var.user_data
  key_name                             = var.key_name
  subnet_id                            = var.subnet_id
  associate_public_ip_address          = var.associate_public_ip_address
  private_ip                           = var.private_ip
  ipv6_address_count                   = var.ipv6_address_count
  ipv6_addresses                       = var.ipv6_addresses
  vpc_security_group_ids               = var.vpc_security_group_ids
  monitoring                           = var.monitoring
  tenancy                              = var.tenancy
  ebs_optimized                        = var.ebs_optimized
  disable_api_termination              = var.disable_api_termination
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  source_dest_check                    = var.source_dest_check
  hibernation                          = var.hibernation
  get_password_data                    = var.get_password_data

  cpu_options {
    core_count                         = 2
    threads_per_core                   = 2
  }

  credit_specification {
    cpu_credits = var.cpu_credits
  }

  capacity_reservation_specification {
    capacity_reservation_preference    = var.capacity_reservation_preference
  }

  enclave_options {
    enabled                            = var.enclave_enabled
  }

  maintenance_options {
    auto_recovery                      = var.auto_recovery
  }

  metadata_options {
    http_endpoint                      = var.http_endpoint
    http_tokens                        = var.http_tokens
    http_put_response_hop_limit        = var.http_put_response_hop_limit
    instance_metadata_tags             = var.instance_metadata_tags
  }

  placement_group = var.placement_group
  host_id         = var.host_id

  root_block_device {
    volume_type                        = var.root_volume_type
    volume_size                        = var.root_volume_size
    iops                               = var.root_iops
    throughput                         = var.root_throughput
    delete_on_termination              = var.root_delete_on_termination
    encrypted                          = var.root_encrypted
    kms_key_id                         = var.root_kms_key_id
    tags                               = var.root_tags
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_devices
    content {
      device_name                      = ebs_block_device.value.device_name
      volume_type                      = ebs_block_device.value.volume_type
      volume_size                      = ebs_block_device.value.volume_size
      iops                             = ebs_block_device.value.iops
      throughput                       = ebs_block_device.value.throughput
      delete_on_termination            = ebs_block_device.value.delete_on_termination
      encrypted                        = ebs_block_device.value.encrypted
      kms_key_id                       = ebs_block_device.value.kms_key_id
      snapshot_id                      = ebs_block_device.value.snapshot_id
      tags                             = ebs_block_device.value.tags
    }
  }

  dynamic "network_interface" {
    for_each = var.network_interfaces
    content {
      device_index                     = network_interface.value.device_index
      network_interface_id             = network_interface.value.network_interface_id
    }
  }

  tags                                 = var.tags
}
