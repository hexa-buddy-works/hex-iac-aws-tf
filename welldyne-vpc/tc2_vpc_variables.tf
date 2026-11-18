variable "wd_region"{
  type              = map(string)
  default           = {
    home_region     = "us-east-1"
    dr_region       = "us-west-2"
  }
  description       = "Map of home and DR regions."
}

variable prov_region {
  type              = string
  default           = "home_region"
  description       = "Provisioning region."
}

variable "cidr_block" {
  description = "IPv4 CIDR block assigned to the VPC."
  type        = string
}

variable "instance_tenancy" {
  description = "Tenancy option for instances launched into the VPC."
  type        = string
  default     = "default"

  validation {
    condition = contains(
      [
        "default",
        "dedicated"
      ],
      var.instance_tenancy
    )
    error_message = "Instance_tenancy must be default or dedicated."
  }
}

variable "enable_dns_support" {
  description = "Whether DNS resolution through the Amazon-provided DNS server is enabled."
  type        = bool
  default     = false
}

variable "enable_dns_hostnames" {
  description = "Whether instances launched in the VPC receive DNS hostnames."
  type        = bool
  default     = false
}

variable "enable_network_address_usage_metrics" {
  description = "Whether Network Address Usage metrics are enabled for the VPC."
  type        = bool
  default     = false
}

variable "prov_tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
}
