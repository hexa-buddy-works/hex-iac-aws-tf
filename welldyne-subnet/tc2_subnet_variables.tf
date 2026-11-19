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