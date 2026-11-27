module "dev_vpc" {
  source      = "./welldyne-vpc"
  prov_region = "home_region"
  vpc_count   = 2
  prov_tags   = {
        environment = "dev"
        name        = "welldyne-vpc-dev-1"
      }
  vpcs = [
    {
      cidr_block                           = "10.0.0.0/16"
      instance_tenancy                     = "default"
      enable_network_address_usage_metrics = false
    },
    {
      cidr_block                           = "10.1.0.0/16"
      instance_tenancy                     = "default"
      enable_network_address_usage_metrics = false
    }
  ]

  providers = {
    aws = aws.home
  }
}

module "dev_subnet" {
  source           = "./welldyne-subnet"
  prov_subnet_type = "private"
  prov_region      = "home_region"
  vpc_id           = module.dev_vpc.vpc_id[0]
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
  vpc_cidr_block      = module.dev_vpc.vpc_cidr_block[0]
  subnet_newbits_list = [11, 12]
}

module "qa_subnet" {
  source           = "./welldyne-subnet"
  prov_subnet_type = "private"
  prov_region      = "home_region"
  vpc_id           = module.qa_vpc.vpc_id[0]
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
  vpc_cidr_block = module.qa_vpc.vpc_cidr_block[0]
  subnet_newbits = 10
}

module "dev_gwlb" {
  source      = "./welldyne-gwlb"
  prov_region = "home_region"
  vpc_id      = module.dev_vpc.vpc_id[0]
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
  vpc_id      = module.qa_vpc.vpc_id[0]
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

module "uat_subnet" {
  source           = "./welldyne-subnet"
  prov_subnet_type = "private"
  prov_region      = "home_region"
  vpc_id           = module.qa_vpc.vpc_id[0]
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
  vpc_cidr_block  = module.qa_vpc.vpc_cidr_block[0]
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

module "dev_eip" {
  source = "./welldyne-eip"
  prov_region = "home_region"
  eips = {
    nat_eip_1 = {
      domain = "vpc"
      tags = {
        environment = "dev"
        purpose = "nat"
      }
    }
    nat_eip_2 = {
      domain = "vpc"
      tags = {
        environment = "dev"
        purpose = "nat"
      }
    }

    gwlb_eip = {
      domain = "vpc"
      tags = {
        environment = "dev"
        purpose = "gwlb"
      }
    }
  }

  prov_tags = {
    application = "welldyne"
  }

  providers = {
    aws = aws.home
  }
}

module "qa_eip" {
  source = "./welldyne-eip"
  prov_region = "home_region"
  eips = {
    qa_nat_eip_1 = {
      domain = "vpc"
      tags = {
        environment = "qa"
        purpose     = "nat"
      }
    }

    qa_nat_eip_2 = {
      domain = "vpc"
      tags = {
        environment = "qa"
        purpose     = "nat"
      }
    }
    qa_gwlb_eip = {
      domain = "vpc"
      tags = {
        environment = "qa"
        purpose     = "gwlb"
      }
    }
  }

  prov_tags = {
    environment = "qa"
  }

  providers = {
    aws = aws.home
  }
}


#Issues
/*
module "dev_gwlbe" {
  source      = "./welldyne-gwlbe"
  prov_region = "home_region"
  vpc_id      = module.dev_vpc.vpc_id[0]
 
  gwlb_endpoint_service_name = module.dev_gwlb.gwlb_endpoint_service_name
 
  gwlbe_count = 2
 
  gwlbes = [
    {
      name       = "welldyne-gwlbe-dev-1"
      gwlb_index = 0
      subnet_id  = module.dev_subnet.subnet_id[0]
    },
    {
      name       = "welldyne-gwlbe-dev-2"
      gwlb_index = 0
      subnet_id  = module.dev_subnet.subnet_id[1]
    }
  ]
 
  prov_tags = {
    environment = "dev"
    application = "welldyne"
    managed_by  = "terraform"
  }
 
  providers = {
    aws = aws.home
  }
}
 
module "qa_gwlbe" {
  source      = "./welldyne-gwlbe"
  prov_region = "home_region"
  vpc_id      = module.qa_vpc.vpc_id[0]
 
  gwlb_endpoint_service_name = module.qa_gwlb.gwlb_endpoint_service_name
 
  gwlbe_count = 2
 
  gwlbes = [
    {
      name       = "welldyne-gwlbe-qa-1"
      gwlb_index = 0
      subnet_id  = module.qa_subnet.subnet_id[0]
    },
    {
      name       = "welldyne-gwlbe-qa-2"
      gwlb_index = 0
      subnet_id  = module.qa_subnet.subnet_id[1]
    }
  ]
 
  prov_tags = {
    environment = "qa"
    application = "welldyne"
    managed_by  = "terraform"
  }
 
  providers = {
    aws = aws.home
  }
}

module "dev_route_table" {
  source      = "./welldyne-routetable"
  prov_region = "home_region"
  vpc_id = module.dev_vpc.vpc_id[0]
  route_tables = {
    private_rt_1 = {
      subnet_ids = [
        module.dev_subnet.subnet_id[0]
      ]
      routes = {
        default = {
          destination_cidr_block = "0.0.0.0/0"
          vpc_endpoint_id = module.dev_gwlbe.gwlbe_id[0]
        }
      }
    }
    private_rt_2 = {
      subnet_ids = [
        module.dev_subnet.subnet_id[1]
      ]
      routes = {
        default = {
          destination_cidr_block = "0.0.0.0/0"
          vpc_endpoint_id = module.dev_gwlbe.gwlbe_id[0]
        }
        internal = {
          destination_cidr_block = "10.100.0.0/16"
          transit_gateway_id = "tgw-xxxxxxxx"
        }
      }
    }
 
    inspection_rt = {
      subnet_ids = [
        module.uat_subnet.subnet_id[0]
      ]
      routes = {
        internet = {
          destination_cidr_block = "0.0.0.0/0"
          gateway_id = "igw-xxxxxxxx"
        }
        spoke = {
          destination_cidr_block = "172.16.0.0/12"
          transit_gateway_id = "tgw-yyyyyyyy"
        }
      }
    }
  }
 
  prov_tags = {
    environment = "dev"
    project = "welldyne"
  }
 
  providers = {
    aws = aws.home
  }
}
 
module "qa_route_table" {
  source      = "./welldyne-routetable"
  prov_region = "home_region"
  vpc_id = module.qa_vpc.vpc_id[0]
  route_tables = {
    qa_private_rt_1 = {
      subnet_ids = [
        module.qa_subnet.subnet_id[0]
      ]
      routes = {
        to_gwlbe = {
          destination_cidr_block = "0.0.0.0/0"
          vpc_endpoint_id = module.qa_gwlbe.gwlbe_id[0]
        }
      }
    }
 
    qa_private_rt_2 = {
      subnet_ids = [
        module.qa_subnet.subnet_id[1]
      ]
      routes = {
        to_gwlbe = {
          destination_cidr_block = "0.0.0.0/0"
          vpc_endpoint_id = module.qa_gwlbe.gwlbe_id[0]
        }
      }
    }
  }
 
  prov_tags = {
    environment = "qa"
    application = "welldyne"
  }
 
  providers = {
    aws = aws.home
  }
}

*/