locals {
  nlb_load_balancer_type     = "network"
  enable_deletion_protection = true
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

variable "prov_tags" {
  description = "A map of tags to assign to the resources. Must include a name key."
  type        = map(string)
}

variable "nlb_count" {
  description = "Number of NLBs to create."
  type        = number
}

variable "vpc_id" {
  description = "ID of the VPC."
  type        = string
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

variable "nlb_target_groups" {
  description = "List of target groups for NLB"
  type = list(object({
    name                  = string
    weight                = number
    target_type           = string
    protocol              = string
    port                  = number
    health_check_protocol = string
    health_check_port     = number
  }))
}

variable "nlb_listeners" {
  description = "List of listeners for NLB"
  type = list(object({
    name              = string
    nlb_name          = string
    port              = number
    protocol          = string
    target_group_names = list(string)
  }))
}

variable "nlb_target_group_attachments" {
  description = "List of target group attachments for NLB"
  type = list(object({
    target_group_name = string
    target_id         = string
    target_port       = number
  }))
}

locals {

  target_group_arns = {
    for name, tg in aws_lb_target_group.wd_nlb_tg :
    name => tg.arn
  }

  target_groups_weight = {
    for tg in var.nlb_target_groups :
    tg.name => tg.weight
  }

  nlb_arns = {
    for name, nlb in aws_lb.wd_nlb : name => nlb.arn
  }
}
