variable "wd_region" {
  type = map(string)
  
  default = {
    home_region = "us-east-1"
    dr_region   = "us-west-2"
  }
}

variable "prov_region" {
  type = string

  validation {
    condition     = contains(["home_region", "dr_region"], var.prov_region)
    error_message = "prov_region must be home_region or dr_region."
  }
}

variable "prov_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "eips" {
  description = "Map of EIPs to create"
  type = map(object({
    domain = optional(string, "vpc")
    tags = optional(map(string), {})
  }))
}