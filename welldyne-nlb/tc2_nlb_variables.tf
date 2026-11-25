variable "nlb_count" {
  description = "Number of NLBs to create."
  type        = number
  default     = 1
}

variable "nlb_load_balancer_type" {
  description = "Type of load balancer: application or network."
  type        = string
  default     = "network"
  validation {
    condition     = contains(["application", "network"], var.nlb_load_balancer_type)
    error_message = "nlb_load_balancer_type must be application or network."
  }
}

variable "nlbs" {
  description = "List of names for the NLBs."
  type        = list(object({
    name = string
    nlb_internal = bool
    subnet_mappings = list(object({
      subnet_id = string
      allocation_id = optional(string)
      private_ipv4_address = optional(string)
    }))
  }))
}

variable "vpc_id" {
  description = "ID of the VPC (from: terraform output vpc_id in welldyne-vpc)."
  type        = string
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
  default     = true
}

variable "enable_deletion_protection" {
  description = "Whether deletion protection is enabled on the load balancer."
  type        = bool
  default     = false
}

variable "prov_tags" {
  description = "A map of tags to assign to the resources. Must include a name key."
  type        = map(string)
}

variable "nlb_target_groups" {
  description = "List of target groups for NLB"
  type = list(object({
    name        = string
    weight      = number
    target_type = string
    protocol    = string
    port        = number
  }))
}