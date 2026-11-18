module "dev_vpc" {
  source                   = "./welldyne-vpc"
  prov_region              = "home_region"
  cidr_block               = "10.0.0.0/16"
  instance_tenancy         = "default"
  prov_tags                = {
    "environment" = "dev"
    "name"        = "welldyne-vpc-dev"
  }
  providers                = {
    aws                    = aws.home
  }
}

module "qa_vpc" {
  source                   = "./welldyne-vpc"
  prov_region              = "home_region"
  cidr_block               = "10.0.0.0/16"
  instance_tenancy         = "default"
  prov_tags                = {
    "environment" = "qa"
    "name"        = "welldyne-vpc-qa"
  }
  providers                = {
    aws                    = aws.home
  }
}