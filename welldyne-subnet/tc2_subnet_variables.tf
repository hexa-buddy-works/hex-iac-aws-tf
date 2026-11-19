variable "vpc_id" {
  description = "VPC ID where the subnet will be created."
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone for the subnet."
  type        = string
  default     = null
}

variable "availability_zone_id" {
  description = "Availability Zone ID for the subnet."
  type        = string
  default     = null
}

variable "cidr_block" {
  description = "IPv4 CIDR block for the subnet."
  type        = string
  default     = null
}

variable "customer_owned_ipv4_pool" {
  description = "Customer-owned IPv4 pool ID."
  type        = string
  default     = null
}

variable "enable_dns64" {
  description = "Enable DNS64 for the subnet."
  type        = bool
  default     = false
}

variable "enable_lni_at_device_index" {
  description = "Device index for LNI."
  type        = number
  default     = null
}

variable "enable_resource_name_dns_a_record_on_launch" {
  description = "Enable resource-name DNS A records on launch."
  type        = bool
  default     = false
}

variable "ipv4_ipam_pool_id" {
  description = "IPv4 IPAM pool ID."
  type        = string
  default     = null
}

variable "ipv4_netmask_length" {
  description = "IPv4 netmask length when using an IPAM pool."
  type        = number
  default     = null
}

variable "map_customer_owned_ip_on_launch" {
  description = "Map customer-owned IP addresses on launch."
  type        = bool
  default     = false
}

variable "map_public_ip_on_launch" {
  description = "Assign a public IPv4 address when launching an instance."
  type        = bool
  default     = false
}

variable "private_dns_hostname_type_on_launch" {
  description = "Private DNS hostname type assigned on launch."
  type        = string
  default     = "ip-name"

  validation {
    condition = contains(
      ["ip-name", "resource-name"],
      var.private_dns_hostname_type_on_launch
    )

    error_message = "The value must be either ip-name or resource-name."
  }
}

variable "tags" {
  description = "Tags to apply to the subnet."
  type        = map(string)
  default     = {}
}