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

variable "vpc_id" {
  description = "ID of the VPC the route table belongs to."
  type        = string
}

variable "prov_tags" {
  description = "A map of tags to assign to the route table."
  type        = map(string)
}

variable "subnet_ids" {
  description = "Subnet IDs to associate with this route table."
  type        = list(string)
}

variable "routes" {
  description = "Map of routes. The key is any label you like. Set only ONE target per route."
  type = map(object({
    destination_cidr_block = string
    gateway_id             = optional(string)
    nat_gateway_id         = optional(string)
    vpc_endpoint_id        = optional(string)
    transit_gateway_id     = optional(string)
  }))
  default = {}
}