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

 module "dev_nlb" {
   source                   = "./welldyne-nlb"
   prov_region              = "home_region"
   vpc_id                   = module.dev_vpc.vpc_id
   nlb_name                 = "welldyne-nlb-dev"
   nlb_subnet_ids           = module.dev_subnet.subnet_id
   prov_tags                = {
    "environment" = "dev"
    "name"        = "welldyne-nlb-dev"
   }
   providers ={
    aws=aws.home
   }  
 }


 module "qa_nlb" {
   source                   = "./welldyne-nlb"
   prov_region              = "home_region"
   vpc_id                   = module.qa_vpc.vpc_id
   nlb_name                 = "welldyne-nlb-qa"
   nlb_subnet_ids           = module.qa_subnet.subnet_id
   prov_tags                ={
    "environemt" = "qa"
    "name" ="welldyne-nlb-qa"
   }
   providers = {
    aws=aws.home
   }
 }

 module "dev_gwlb" {
  source                   = "./welldyne-gwlb"
  prov_region              = "home_region"
  vpc_id                   = module.dev_vpc.vpc_id
  gwlb_name                = "welldyne-gwlb-dev"
  gwlb_subnet_ids          = module.dev_subnet.subnet_id
  prov_tags                = {
    "environment" = "dev"
    "name"        = "welldyne-gwlb-dev"
  }
  providers = {
    aws = aws.home
  }
 }

 module "qa_gwlb" {
  source                   = "./welldyne-gwlb"
  prov_region              = "home_region"
  vpc_id                   = module.qa_vpc.vpc_id
  gwlb_name                = "welldyne-gwlb-qa"
  gwlb_subnet_ids          = module.qa_subnet.subnet_id
  prov_tags                = {
    "environment" = "qa"
    "name"        = "welldyne-gwlb-qa"
  }
  providers = {
    aws = aws.home
  }
 }

 module "dev_gwlbe" {
  source                   = "./welldyne-gwlbe"
  prov_region              = "home_region"
  vpc_id                   = module.dev_vpc.vpc_id
  gwlb_service_name        = module.dev_gwlb.gwlb_endpoint_service_name
  gwlbe_subnet_ids         = module.dev_subnet.subnet_id
  prov_tags                = {
    "environemt"  =  "dev"
    "name"        =  "welldyne-gwlbe-dev"
  }
  providers = {
    aws = aws.home
  }
 }

 module "qa_gwlbe" {
  source                   = "./welldyne-gwlbe"
  prov_region              = "home_region"
  vpc_id                   = module.qa_vpc.vpc_id
  gwlb_service_name        = module.qa_gwlb.gwlb_endpoint_service_name
  gwlbe_subnet_ids         = module.qa_subnet.subnet_id
  prov_tags                = {
    "environemt"  =  "qa"
    "name"        =  "welldyne-gwlbe-qa"
  }
  providers = {
    aws = aws.home
  }
 }

 module "dev_route_table"  {
  source                   = "./welldyne-routetable"
  prov_region              = "home_region"
  vpc_id                   = module.dev_vpc.vpc_id
  subnet_ids               = module.dev_subnet.subnet_id
  routes = {
    to_gwlbe = {
      destination_cidr_block = "0.0.0.0/0"
      vpc_endpoint_id        = module.dev_gwlbe.gwlbe_id
    }
  }
  prov_tags = {
    "environmet" = "dev"
    "name"       = "welldyne-rt-dev"
  }
  providers = {
    aws = aws.home
  }
 }

 module "qa_route_table"  {
  source                   = "./welldyne-routetable"
  prov_region              = "home_region"
  vpc_id                   = module.qa_vpc.vpc_id
  subnet_ids               = module.qa_subnet.subnet_id
  routes = {
    to_gwlbe = {
      destination_cidr_block = "0.0.0.0/0"
      vpc_endpoint_id        = module.qa_gwlbe.gwlbe_id
    }
  }
  prov_tags = {
    "environmet" = "qa"
    "name"       = "welldyne-rt-qa"
  }
  providers = {
    aws = aws.home
  }
 }