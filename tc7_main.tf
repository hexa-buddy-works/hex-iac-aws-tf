module "dev_vpc" {
  source           = "./welldyne-vpc"
  prov_region      = "home_region"
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  prov_tags = {
    "environment" = "dev"
    "name"        = "welldyne-vpc-dev"
  }
  providers = {
    aws = aws.home
  }
}

module "qa_vpc" {
  source           = "./welldyne-vpc"
  prov_region      = "home_region"
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  prov_tags = {
    "environment" = "qa"
    "name"        = "welldyne-vpc-qa"
  }
  providers = {
    aws = aws.home
  }
}

module "dev_subnet" {
  source           = "./welldyne-subnet"
  prov_subnet_type = "private"
  prov_region      = "home_region"
  vpc_id           = module.dev_vpc.vpc_id
  cidr_block       = "10.0.1.0/24"
  prov_tags = {
    "environment" = "dev"
    "name"        = "welldyne-pri-sn-dev"
  }
  availability_zone = "us-east-1a"
  providers = {
    aws = aws.home
  }
  subnet_count        = 2
  vpc_cidr_block      = module.dev_vpc.vpc_cidr_block
  subnet_newbits_list = [11, 12]
}

module "qa_subnet" {
  source           = "./welldyne-subnet"
  prov_subnet_type = "private"
  prov_region      = "home_region"
  vpc_id           = module.qa_vpc.vpc_id
  cidr_block       = "10.0.1.0/24"
  prov_tags = {
    "environment" = "qa"
    "name"        = "welldyne-pri-sn-qa"
  }
  availability_zone = "us-east-1a"
  providers = {
    aws = aws.home
  }
  subnet_count   = 2
  vpc_cidr_block = module.qa_vpc.vpc_cidr_block
  subnet_newbits = 10
}



/*
module "dev_gwlb" {
  source      = "./welldyne-gwlb"
  prov_region = "home_region"
  vpc_id      = module.dev_vpc.vpc_id

  gwlb_count = 1

  gwlbs = [
    {
      name = "welldyne-gwlb-dev"

      subnet_mappings = [
        {
          subnet_id = module.dev_subnet.subnet_id[0]
        },
        {
          subnet_id = module.dev_subnet.subnet_id[1]
        }
      ]
    }
  ]

  gwlb_target_groups = [
    {
      name              = "welldyne-gwlb-dev-tg"
      target_type       = "instance"
      health_check_port = 80
    }
  ]

  prov_tags = {
    environment = "dev"
    name        = "welldyne-gwlb-dev"
  }

  providers = {
    aws = aws.home
  }
}

module "qa_gwlb" {
  source      = "./welldyne-gwlb"
  prov_region = "home_region"
  vpc_id      = module.qa_vpc.vpc_id

  gwlb_count = 1

  gwlbs = [
    {
      name = "welldyne-gwlb-qa"

      subnet_mappings = [
        {
          subnet_id = module.qa_subnet.subnet_id[0]
        },
        {
          subnet_id = module.qa_subnet.subnet_id[1]
        }
      ]
    }
  ]

  gwlb_target_groups = [
    {
      name              = "welldyne-gwlb-qa-tg"
      target_type       = "instance"
      health_check_port = 80
    }
  ]

  prov_tags = {
    environment = "qa"
    name        = "welldyne-gwlb-qa"
  }

  providers = {
    aws = aws.home
  }
}
*/


 module "dev_gwlbe" {
  source                   = "./welldyne-gwlbe"
  prov_region              = "home_region"
  vpc_id                   = module.dev_vpc.vpc_id
  gwlb_service_name        = module.qa_gwlb.gwlb_endpoint_service_name[0]
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
  gwlb_service_name        = module.dev_gwlb.gwlb_endpoint_service_name[0]
  gwlbe_subnet_ids         = module.qa_subnet.subnet_id
  prov_tags                = {
    "environemt"  =  "qa"
    "name"        =  "welldyne-gwlbe-qa"
  }
  providers = {
    aws = aws.home
  }
 }

module "dev_gwlb" {
  source      = "./welldyne-gwlb"
  prov_region = "home_region"
  vpc_id      = module.dev_vpc.vpc_id
  gwlb_count = 1
  gwlbs = [
    {
      name = "welldyne-gwlb-dev"
      subnet_mappings = [
        {
          subnet_id = module.dev_subnet.subnet_id[0]
        },
        {
          subnet_id = module.dev_subnet.subnet_id[1]
        }
      ]
    }
  ]
  gwlb_target_groups = [
    {
      name              = "welldyne-gwlb-dev-tg"
      target_type       = "instance"
      health_check_port = 80
    }
  ]
  prov_tags = {
    environment = "dev"
    name        = "welldyne-gwlb-dev"
  }
  providers = {
    aws = aws.home
  }
}

module "qa_gwlb" {
  source      = "./welldyne-gwlb"
  prov_region = "home_region"
  vpc_id      = module.qa_vpc.vpc_id
  gwlb_count = 1
  gwlbs = [
    {
      name = "welldyne-gwlb-qa"
      subnet_mappings = [
        {
          subnet_id = module.qa_subnet.subnet_id[0]
        },
        {
          subnet_id = module.qa_subnet.subnet_id[1]
        }
      ]
    }
  ]
  gwlb_target_groups = [
    {
      name              = "welldyne-gwlb-qa-tg"
      target_type       = "instance"
      health_check_port = 80
    }
  ]
  prov_tags = {
    environment = "qa"
    name        = "welldyne-gwlb-qa"
  }
  providers = {
    aws = aws.home
  }
}

module "dev_route_table" {
  source      = "./welldyne-routetable"
  prov_region = "home_region"
  vpc_id      = module.dev_vpc.vpc_id
  subnet_ids  = module.dev_subnet.subnet_id
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

module "qa_route_table" {
  source      = "./welldyne-routetable"
  prov_region = "home_region"
  vpc_id      = module.qa_vpc.vpc_id
  subnet_ids  = module.qa_subnet.subnet_id
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

module "uat_subnet" {
  source           = "./welldyne-subnet"
  prov_subnet_type = "private"
  prov_region      = "home_region"
  vpc_id           = module.qa_vpc.vpc_id
  cidr_block       = "10.0.1.0/24"
  prov_tags = {
    "environment" = "qa"
    "name"        = "welldyne-pri-sn-qa"
  }
  availability_zone = "us-east-1a"
  providers = {
    aws = aws.home
  }
  subnet_count    = 3
  vpc_cidr_block  = module.qa_vpc.vpc_cidr_block
  subnet_newbits  = 10
  same_az_subnets = true
  cidr_blocks     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

module "scp_apply" {
  source          = "./welldyne-scp"
  scp_name        = "DenyAllExceptBilling"
  scp_description = "Deny all actions except billing and budgets"
  scp_policy      = <<EOF
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
  target_ou_id    = "ou-xxxx-xxxxxxxx"
  tags = {
    "name" = "welldyne-scp-denyall-except-billing-budgtes"
  }
  providers = {
    aws = aws.home
  }
}

module "welldyne-dev-nlb" {
  source      = "./welldyne-nlb"
  prov_region = "home_region"
  vpc_id      = module.dev_vpc.vpc_id
  nlb_count   = 1
  nlbs = [
    {
      name         = "welldyne-nlb-dev"
      nlb_internal = true
      subnet_mappings = [
        {
          subnet_id            = module.dev_subnet.subnet_id[0]
          private_ipv4_address = "10.0.1.10"
        },
        {
          subnet_id            = module.dev_subnet.subnet_id[1]
          private_ipv4_address = "10.0.2.10"
        }
      ]
    }
  ]
  nlb_target_groups = [
    {
      name        = "welldyne-nlb-tg-web-1"
      port        = 80
      protocol    = "TCP"
      target_type = "ip"
      weight      = 50
    },
    {
      name        = "welldyne-nlb-tg-web-2"
      port        = 80
      protocol    = "TCP"
      target_type = "ip"
      weight      = 50
    },
    {
      name        = "welldyne-nlb-tg-TLS-1"
      port        = 443
      protocol    = "TCP"
      target_type = "ip"
      weight      = 50
    },
    {
      name        = "welldyne-nlb-tg-TLS-2"
      port        = 443
      protocol    = "TCP"
      target_type = "ip"
      weight      = 50
    }
  ]
  prov_tags = {
    "environment" = "dev"
    "name"        = "welldyne-nlb-dev"
  }
  providers = {
    aws = aws.home
  }

}