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

variable "nlb_name" {
  description = "Name of the NLB (letters, numbers and hyphens only, max 29 characters so the target group name fits)."
  type        = string
}

variable "nlb_internal" {
  description = "true = internal NLB (private subnets), false = internet-facing (public subnets)."
  type        = bool
  default     = true
}

variable "nlb_subnet_ids" {
  description = "Subnet IDs for the NLB, one per Availability Zone."
  type        = list(string)
}

variable "nlb_ip_address_type" {
  description = "IP address type of the NLB: ipv4 or dualstack."
  type        = string
  default     = "ipv4"
  validation {
    condition     = contains(["ipv4", "dualstack"], var.nlb_ip_address_type)
    error_message = "nlb_ip_address_type must be ipv4 or dualstack."
  }
}

variable "nlb_enable_cross_zone_load_balancing" {
  description = "Whether the NLB spreads traffic across targets in all AZs."
  type        = bool
  default     = false
}

variable "nlb_listener_port" {
  description = "Port the NLB listens on."
  type        = number
  default     = 80
}

variable "nlb_target_port" {
  description = "Port on the targets that receives traffic."
  type        = number
  default     = 80
}

variable "nlb_target_type" {
  description = "Target type for the target group: instance or ip."
  type        = string
  default     = "instance"
  validation {
    condition     = contains(["instance", "ip"], var.nlb_target_type)
    error_message = "nlb_target_type must be instance or ip."
  }
}

