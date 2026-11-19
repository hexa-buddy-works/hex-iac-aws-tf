variable "wd_region" {
  type = map(string)
  default = {
    home_region = "us-east-1"
    dr_region   = "us-west-2"
  }
  description = "Map of home and DR regions."
}

variable "prov_region" {
  type        = string
  default     = "home_region"
  description = "Provisioning region (selector)."
  validation {
    condition     = contains(["home_region", "dr_region"], var.prov_region)
    error_message = "prov_region must be home_region or dr_region."
  }
}


variable "subnet_types" {
  description = "Map of subnet types and their settings."
  type = map(object({
    cidr_block              = string
    map_public_ip_on_launch = bool
  }))
  default = {
    public_subnet = {
      cidr_block              = "10.0.1.0/24"
      map_public_ip_on_launch = true
    }
    private_subnet = {
      cidr_block              = "10.0.2.0/24"
      map_public_ip_on_launch = false
    }
  }
}

variable "subnet_type" {
  description = "Which subnet type to create (selector)."
  type        = string
  default     = "private_subnet"
  validation {
    condition     = contains(["public_subnet", "private_subnet"], var.subnet_type)
    error_message = "subnet_type must be public_subnet or private_subnet."
  }
}


variable "vpc_id" {
  description = "ID of the VPC the subnet belongs to."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the subnet."
  type        = map(string)
}



variable "availability_zone" {
  description = "AZ name (e.g. us-east-1a). Use this or availability_zone_id, not both."
  type        = string
  default     = null
}


variable "customer_owned_ipv4_pool" {
  description = "Customer-owned IPv4 pool (Outposts only)."
  type        = string
  default     = null
}

variable "enable_dns64" {
  description = "Whether DNS64 is enabled."
  type        = bool
  default     = false
}

variable "enable_lni_at_device_index" {
  description = "Device index for a local network interface (Outposts/Local Zones)."
  type        = number
  default     = null
}

variable "enable_resource_name_dns_a_record_on_launch" {
  description = "Whether to create a DNS A record for the resource name on launch."
  type        = bool
  default     = false
}

variable "ipv4_ipam_pool_id" {
  description = "IPAM pool ID. Use instead of cidr_block."
  type        = string
  default     = null
}

variable "ipv4_netmask_length" {
  description = "Netmask length requested from the IPAM pool."
  type        = number
  default     = null
}

variable "map_customer_owned_ip_on_launch" {
  description = "Assign customer-owned IPs on launch (Outposts only)."
  type        = bool
  default     = false
}

variable "private_dns_hostname_type_on_launch" {
  description = "Hostname type for instances: ip-name or resource-name."
  type        = string
  default     = null
}