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
  description = "Provisioning region (selector)."
  validation {
    condition     = contains(["home", "dr"], var.prov_region)
    error_message = "prov_region must be home or dr."
  }
}

variable "subnet_type" {
  description = "This is a map of the subnet types."
  type        = map(string)
  default = {
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

variable "enable_dns64" {
  description = "Whether DNS64 is enabled."
  type        = bool
  default     = false
}

variable "subnet_count" {
  description = "Number of subnets to create."
  type        = number
  default     = 1
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default = "10.0.0.0/16"
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
  effective_subnet_count = var.same_az_subnets == false || var.availability_zones == null ? min(var.subnet_count, length(data.aws_availability_zones.available.names)) : var.subnet_count
}

variable "same_az_subnets" {
  description = "Whether to create subnets in the same availability zone."
  type        = bool
  default     = false
}

variable "availability_zone" {
  description = "Availability zone name."
  type        = string
  default     = "us-east-1a"
}
variable "cidr_blocks" {
  description = "List of CIDR blocks for the subnets."
  type        = list(string)
  default     = null

}

variable "availability_zones" {
  description = "List of availability zones."
  type        = list(string)
  default     = null
}


locals {
  azs = var.availability_zones != null ? var.availability_zones : data.aws_availability_zones.available.names
  azs_status = var.availability_zones == null && var.subnet_count == length(data.aws_availability_zones.available.names)
}