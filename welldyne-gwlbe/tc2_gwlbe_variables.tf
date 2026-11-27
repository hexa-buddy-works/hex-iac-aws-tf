variable "gwlbe_count" {
  description = "Number of GWLB endpoints to create. Must match the length of var.gwlbes."
  type        = number
  default     = 1

  validation {
    condition = (
      var.gwlbe_count > 0 &&
      var.gwlbe_count == floor(var.gwlbe_count)
    )
    error_message = "gwlbe_count must be a positive integer."
  }
}

variable "gwlbes" {
  description = "List of GWLB endpoints. One endpoint must be provided per subnet and Availability Zone."

  type = list(object({
    name       = string
    gwlb_index = number
    subnet_id  = string
  }))

  validation {
    condition     = length(var.gwlbes) > 0
    error_message = "gwlbes must contain at least one endpoint definition."
  }

  validation {
    condition = alltrue([
      for endpoint in var.gwlbes :
      length(trimspace(endpoint.name)) > 0
    ])
    error_message = "Each GWLB endpoint must have a non-empty name."
  }

  validation {
    condition = alltrue([
      for endpoint in var.gwlbes :
      length(trimspace(endpoint.subnet_id)) > 0
    ])
    error_message = "Each GWLB endpoint must have a non-empty subnet_id."
  }

  validation {
    condition = alltrue([
      for endpoint in var.gwlbes :
      endpoint.gwlb_index >= 0 &&
      endpoint.gwlb_index == floor(endpoint.gwlb_index)
    ])
    error_message = "Each gwlb_index must be a non-negative integer."
  }

  validation {
    condition = (
      length(distinct([
        for endpoint in var.gwlbes : endpoint.name
      ])) == length(var.gwlbes)
    )
    error_message = "Each GWLB endpoint name must be unique."
  }

  validation {
    condition = (
      length(distinct([
        for endpoint in var.gwlbes : endpoint.subnet_id
      ])) == length(var.gwlbes)
    )
    error_message = "Each GWLB endpoint must use a unique subnet_id."
  }
}

variable "gwlb_endpoint_service_name" {
  description = "GWLB endpoint service names exported by the welldyne-gwlb module."
  type        = list(string)

  validation {
    condition = (
      length(var.gwlb_endpoint_service_name) > 0 &&
      alltrue([
        for service_name in var.gwlb_endpoint_service_name :
        length(trimspace(service_name)) > 0
      ])
    )
    error_message = "gwlb_endpoint_service_name must contain at least one non-empty service name."
  }
}

variable "wd_region" {
  description = "Map of home and disaster-recovery AWS regions."
  type        = map(string)

  default = {
    home_region = "us-east-1"
    dr_region   = "us-west-2"
  }
}

variable "prov_region" {
  description = "Logical provisioning region selector."
  type        = string
  default     = "home_region"

  validation {
    condition     = contains(["home_region", "dr_region"], var.prov_region)
    error_message = "prov_region must be either home_region or dr_region."
  }
}

variable "vpc_id" {
  description = "ID of the VPC in which the GWLB endpoints will be created."
  type        = string

  validation {
    condition     = length(trimspace(var.vpc_id)) > 0
    error_message = "vpc_id must not be empty."
  }
}

variable "prov_tags" {
  description = "Common tags to apply to the GWLB endpoint resources."
  type        = map(string)
  default     = {}
}