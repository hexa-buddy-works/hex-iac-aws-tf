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
  prov_tags                = {
    "environment"          = "dev"
    "name"                 = "welldyne-pri-sn-dev"
  }
  availability_zone        = "us-east-1a"
  providers                = {
    aws                    = aws.home
  }
  subnet_count             = 2
  vpc_cidr_block           = module.dev_vpc.vpc_cidr_block
  subnet_newbits_list      = [11, 12] 
}

module "qa_subnet" {
  source                   = "./welldyne-subnet"  
  prov_subnet_type         = "private"
  prov_region              = "home_region"
  vpc_id                   = module.qa_vpc.vpc_id
  cidr_block               = "10.0.1.0/24"
  prov_tags                = {
    "environment"          = "qa"
    "name"                 = "welldyne-pri-sn-qa"
  }
  availability_zone        = "us-east-1a"
  providers                = {
    aws                    = aws.home
  }
  subnet_count             = 2
  vpc_cidr_block           = module.qa_vpc.vpc_cidr_block
  subnet_newbits           = 10
}