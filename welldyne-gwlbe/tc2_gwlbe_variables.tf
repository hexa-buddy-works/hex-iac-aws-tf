variable "gwlbe_count" {
  description = "Number of GWLB endpoints to create. Must match length(var.gwlbes)."
  type        = number
  default     = 1
}

variable "gwlbes" {
  description = "List of GWLB endpoints. One endpoint per subnet / Availability Zone."
  type = list(object({
    name       = string # Used in the tag: <name>-gwlbe
    gwlb_index = number # Index into var.gwlb_endpoint_service_name (which GWLB to attach to)
    subnet_id  = string # Single subnet; GWLB endpoints are AZ-specific
  }))

  validation {
    condition     = length(var.gwlbes) > 0
    error_message = "gwlbes must contain at least one endpoint definition."
  }
}

variable "gwlb_endpoint_service_name" {
  description = "Endpoint Service Names (from: terraform output gwlb_endpoint_service_name in welldyne-gwlb)."
  type        = list(string)
}

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
  description = "ID of the VPC (from: terraform output vpc_id in welldyne-vpc)."
  type        = string
}

variable "prov_tags" {
  description = "A map of tags to assign to the resources. Must include a name key."
  type        = map(string)
}