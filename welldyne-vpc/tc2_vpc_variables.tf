variable "wd_region" {
  type = map(string)
  default = {
    home = "us-east-1"
    dr   = "us-west-2"
  }
  description = "Map of home and DR regions."
}

variable "prov_region" {
  type        = string
  default     = "home"
  description = "Provisioning region."
}

locals {
  enable_dns_support         = false
  enable_dns_hostnames       = false
  prevent_destroy            = true
}


variable "prov_tags" {
 description = "A map of tags to assign to the resource."
 type        = map(string)
 validation {
    condition = (
      prov_tags["name"] 
    )
    error_message = "Each VPC prov_tags map must contain a name key."
  }
}

variable "vpc_count" {
  description = "Number of VPCs to create."
  type        = number
  default     = 1

  validation {
    condition = (
      var.vpc_count > 0 && var.vpc_count <= 5
    )

    error_message = "VPC count cannot exceed 5."
  }
}

variable "" {
  description = "Prevent destruction of VPC."
  type        = bool
  default     = true
}

variable "vpcs" {
  description = "List of VPC configurations."

  type = list(object({
    cidr_block                           = string
    instance_tenancy                     = optional(string, "default")
    enable_network_address_usage_metrics = optional(bool, false)
  }))

  validation {
    condition = alltrue([
      for vpc in var.vpcs :
      contains(
        [
          "default",
          "dedicated"
        ],
        vpc.instance_tenancy
      )
    ])

    error_message = "Instance_tenancy must be default or dedicated."
  }

  validation {
    condition = alltrue([
      for vpc in var.vpcs :
      can(cidrhost(vpc.cidr_block, 0))
    ])

    error_message = "Each cidr_block must be a valid CIDR block."
  }

  
}
