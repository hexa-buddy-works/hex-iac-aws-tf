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

variable "gwlb_service_name" {
  description = "Endpoint service name (from: terraform output gwlb_endpoint_service_name in welldyne-gwlb)."
  type        = string
}

variable "gwlbe_subnet_ids" {
  description = "Subnet IDs where the endpoint is created, one per Availability Zone."
  type        = list(string)
}

