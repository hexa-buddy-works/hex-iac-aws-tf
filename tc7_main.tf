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

module "dev_subnet" {
  source                   = "./welldyne-subnet"
  prov_subnet_type         = "private"
  prov_region              = "home_region"
  vpc_id                   = module.dev_vpc.vpc_id
  cidr_block               = "10.0.1.0/24"
  prov_tags               = {
    "environment"          = "dev"
    "name"                 = "welldyne-pri-sn-dev"
  }
}