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

module "uat_subnet" {
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
  subnet_count             = 3
  vpc_cidr_block           = module.qa_vpc.vpc_cidr_block
  subnet_newbits           = 10
  same_az_subnets          = true
  cidr_blocks              = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

module "scp_apply" {
  source                   = "./welldyne-scp"
  scp_name                 = "DenyAllExceptBilling"
  scp_description          = "Deny all actions except billing and budgets"
  scp_policy               = <<EOF
      {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Deny",
            "NotAction": [
              "aws-portal:*",
              "budgets:*"
            ],
            "Resource": "*"
          }
        ]
      }
      EOF
  target_ou_id             = "ou-xxxx-xxxxxxxx"
  tags                     = {
    "name"                 = "welldyne-scp-denyall-except-billing-budgtes"
  }
  providers                = {
    aws                    = aws.home
  }
}