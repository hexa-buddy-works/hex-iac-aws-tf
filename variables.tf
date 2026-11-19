variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "scenario" {
  description = "Used in scenario 2 and 3 for conditional resource creation"
  type        = string
  default     = "single"
}

variable "landing_vpc_cidr" {
  description = "CIDR block for VPC in scenario 4"
  type        = string
  default     = "10.0.0.0/16"
}

variable "project_name" {
  description = "Project name for resource tags"
  type        = string
  default     = "myproject"
}

variable "environment" {
  description = "Environment for resource tags"
  type        = string
  default     = "dev"
}

variable "public_subnet_cidr" {
  description = "CIDR for public subnet in scenario 4"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for private subnet in scenario 4"
  type        = string
  default     = "10.0.2.0/24"
}

variable "az_count" {
  description = "Number of AZs to use in multi-AZ scenarios"
  type        = number
  default     = 3
}

variable "azs" {
  description = "List of AZ names for multi-AZ scenarios"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "vpc_cidr" {
  description = "The VPC CIDR block for general use"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_newbits" {
  description = "Newbits for cidrsubnet in scenario 9"
  type        = number
  default     = 8
}

variable "common_tags" {
  description = "Common tags for resources in scenario 9 and 10"
  type        = map(string)
  default     = {
    Project = "myproject"
    Env     = "dev"
  }
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs for scenarios 5 and 10"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs for scenarios 5 and 8"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
}

variable "name" {
  description = "Name for GWLB target group"
  type        = string
  default     = "gwlb-tg"
}

variable "target_type" {
  description = "Target type for GWLB target group"
  type        = string
  default     = "instance"
}