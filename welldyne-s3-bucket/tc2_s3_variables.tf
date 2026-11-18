variable "bucket" {
  description = "The name of the bucket."
  type        = string
}

variable "acl" {
  description = "Canned ACL to apply."
  type        = string
  default     = "private"
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error."
  type        = bool
  default     = false
}

variable "bucket_prefix" {
  description = "Creates a unique bucket name beginning with the specified prefix."
  type        = string
  default     = null
}

variable "object_lock_enabled" {
  description = "Indicates whether this bucket has an Object Lock configuration enabled."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules."
  type = list(object({
    id      = string
    enabled = bool
    prefix  = string
    tags    = map(string)
    transitions = list(object({
      days          = number
      storage_class = string
    }))
    expiration = object({
      days = number
    })
  }))
  default = []
}

variable "logging" {
  description = "Bucket logging configuration"
  type = object({
    target_bucket = string
    target_prefix = string
  })
  default = null
}

variable "cors_rules" {
  description = "List of CORS rules."
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = list(string)
    max_age_seconds = number
  }))
  default = []
}

variable "policy" {
  description = "Bucket policy JSON."
  type        = string
  default     = null
}

variable "versioning" {
  description = "Enable versioning?"
  type        = bool
  default     = false
}