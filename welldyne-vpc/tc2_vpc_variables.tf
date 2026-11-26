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
  description = "Provisioning region."
}

#variable "cidr_block" {
#  description = "IPv4 CIDR block assigned to the VPC."
#  type        = string
#}

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

#variable "prov_tags" {
#  description = "A map of tags to assign to the resource."
#  type        = map(string)
#}

variable "vpc_count" {
  description = "Number of VPCs to create."
  type        = number
  default     = 1

  validation {
    condition = (
      var.vpc_count > 0 && floor(var.vpc_count) == var.vpc_count
    )

    error_message = "vpc_count must be a positive whole number."
  }
}

variable "vpcs" {
  description = "List of VPC configurations."

  type = list(object({
    cidr_block                           = string
    instance_tenancy                     = optional(string, "default")
    enable_dns_support                   = optional(bool, false)
    enable_dns_hostnames                 = optional(bool, false)
    enable_network_address_usage_metrics = optional(bool, false)
    prov_tags                            = map(string)
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

    error_message = "instance_tenancy must be default or dedicated."
  }

  validation {
    condition = alltrue([
      for vpc in var.vpcs :
      can(cidrhost(vpc.cidr_block, 0))
    ])

    error_message = "Each cidr_block must be a valid CIDR block."
  }

  validation {
    condition = alltrue([
      for vpc in var.vpcs :
      can(vpc.prov_tags["name"])
    ])

    error_message = "Each VPC prov_tags map must contain a name key."
  }
}
