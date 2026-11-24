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

variable "enable_deletion_protection" {
  description = "Whether deletion protection is enabled on the load balancer."
  type        = bool
  default     = false
}

variable "gwlb_name" {
  description = "Name of the GWLB (letters, numbers and hyphens only, max 29 characters so the target group name fits)."
  type        = string
}

variable "gwlb_subnet_ids" {
  description = "Subnet IDs for the GWLB, one per Availability Zone."
  type        = list(string)
}

variable "gwlb_enable_cross_zone_load_balancing" {
  description = "Whether the GWLB spreads traffic across appliances in all AZs."
  type        = bool
  default     = false
}

variable "gwlb_target_type" {
  description = "Target type for the target group: instance or ip."
  type        = string
  default     = "instance"
  validation {
    condition     = contains(["instance", "ip"], var.gwlb_target_type)
    error_message = "gwlb_target_type must be instance or ip."
  }
}

variable "gwlb_health_check_port" {
  description = "Port the GWLB uses to health check the appliances."
  type        = number
  default     = 80
}

variable "gwlb_service_acceptance_required" {
  description = "Whether connection requests to the endpoint service must be manually accepted."
  type        = bool
  default     = false
}

