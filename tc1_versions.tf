terraform {
  required_version = "~> 1.16.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.70.0"
    }
  }
  backend "s3" {
    bucket = "hxw-demo-import-bucket"
    key    = "hex/terraform.tfstate"
    region = "us-east-1"
  }
}
# Default Provider
provider "aws" {
  region = var.wd_region["home_region"]

  default_tags {
    tags = local.tags
  }
}

# Home Region Provider
provider "aws" {
  alias  = "home"
  region = var.wd_region["home_region"]

  default_tags {
    tags = local.tags
  }
}

# DR Region Provider
provider "aws" {
  alias  = "dr"
  region = var.wd_region["dr_region"]

  default_tags {
    tags = local.tags
  }
}