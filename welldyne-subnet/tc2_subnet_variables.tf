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

variable "subnet_type" {
  description = "This is a map of the subnet types."
  type        = map(string)
  default     = {
    public  = true
    private = false
  }
}

variable "prov_subnet_type" {
  description = "Selector for subnet type."
  type        = string
  default     = "private"
  validation {
    condition     = contains(["public", "private"], var.prov_subnet_type)
    error_message = "Subnet type must be public or private."
  }
}

variable "vpc_id" {
  description = "ID of the VPC the subnet belongs to."
  type        = string
}

variable "prov_tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
}

variable "cidr_block" {
  description = "The CIDR block for the subnet."
  type        = string
}

variable "availability_zone" {
  description = "AZ name (e.g. us-east-1a). Use this or availability_zone_id, not both."
  type        = string
  default     = "us-east-1a"
}

variable "enable_dns64" {
  description = "Whether DNS64 is enabled."
  type        = bool
  default     = false
}

variable subnet_count {
  description = "Number of subnets to create."
  type        = number
  default     = 1
}

variable vpc_cidr_block {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "subnet_newbits" {
  description = "The number of new bits to use for subnetting."
  type        = number
  default     = 12
}

variable "subnet_newbits_list" {
  description = "A list of new bits to use for subnetting."
  type        = list(number)
  default     = [12]
  validation {
    condition = (
      #var.subnet_newbits_list == null ||
      length(var.subnet_newbits_list) <= var.subnet_count
    )
    error_message = "subnet_newbits_list cannot exceed subnet_count entries."
  }
}

locals {
  effective_subnet_count = min(
    var.subnet_count,
    length(data.aws_availability_zones.available.names)
  )
}

variable "availability_zone_ids" {
  description = "AZ ID (e.g. use1-az1). Use this or availability_zone, not both."
  type        = list(string)
  default     = null
}

variable "same_az_subnets" {
  description = "Whether to create subnets in the same availability zone."
  type        = bool
  default     = false
}

variable "cidr_blocks" {
  description = "List of CIDR blocks for the subnets."
  type        = list(string)
  default     = null
  
}