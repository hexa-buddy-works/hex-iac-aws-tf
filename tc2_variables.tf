variable "wd_region"{
  type              = map(string)
  default           = {
    home_region     = "us-east-1"
    dr_region       = "us-west-2"
  }
  description       = "Map of home and DR regions for the VPC."
}

variable prov_region {
  type              = string
  default           = "home_region"
  description       = "Provisioning region."
}

locals {
  tags = {
    cost_center = "cost_center"
    project     = "project_name"
    change_id   = "var.change_id"
    region      = var.wd_region["home_region"]
  }
  dr_tags = {
    cost_center = "cost_center"
    project     = "project_name"
    change_id   = "var.change_id"
    region      = var.wd_region["dr_region"]
  }
}