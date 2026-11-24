variable "scp_name" {
  description = "Name for the Service Control Policy"
  type        = string
}

variable "scp_description" {
  description = "Description for the Service Control Policy"
  type        = string
}

variable "scp_policy" {
  description = "SCP policy JSON"
  type        = string
}

variable "target_ou_id" {
  description = "AWS Organization Unit ID to attach the SCP"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the SCP"
  type        = map(string)
  default     = {}
}