# Provision Subnet(s) 
This module creates Subnet(s) in AWS

## Environments
This terraform module developed using terraform version 1.16.4 and AWS provider version 6.70.0

## Module Information
Multiple Subnet(s) can be created using this module. The file sample.txt helps to form the data to create Subnet(s). This module is written as part of Landingzone implementation and migration activity


## Usage

```hcl

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


```

## Inputs

### Argument : subnet_count (number)
Number of VPCs to be created.

### Argument : prov_subnet_type (string - private/public)
The type of the subnet to be created (Private/Public)

### Argument : prov_region (string - home/dr) - provided region
This is the region where the VPC to be provisioned (home or dr)

### Argument : vpc_id (string)
The VPC Id where the Subnet to be created

### Argument : prov_tags (list) - provided tags
To add custom tags. The calling script must pass default tags. The default tags contain the madatory tags like mapid, costcenter etc,.

### Argument : same_az_subnets (bool)- optional
Set this value to 'true' if you want to create subnets in a same availability zone. If the value is set to true, ensure the argument 'availability_zone' value specified based on the requirement.

### Argument : availability_zone (string) - optional 
The availability zone where the Subnet(s) to be created. It defaults to "us-east-1a". Set this argument if the argument 'same_az_subnets' is set to true

### Argument : availability_zones (list) - optional
If the Subnet(s) to be created in multiple availability zones, provide the list of availability zones. If the argument 'subnet_count' and length of this list not matching , error will be thrown

> [!CAUTION]
> If the argument 'same_az_subnets' set to false and argument 'availability_zones' is empty, the script selects the AZ randomly but the argument 'subnet_count' and VPC's region's AZ count must be same.

### Argument : cidr_blocks (list) - optional
The CIDR(s) for the Subnet(s) to be created. The argument 'subnet_count' value and items in this list to be same

### Argument : vpc_cidr_block (string) - optional
The CIDR of the VPC where the Subnets to be created. Provide this value if the subnet CIDR to be calculated automatically.

### Argument : subnet_newbits_list (list) - optional
This list length must be same as the argument 'subnet_count'.  The below is the calculation of CIDR of subnet. 

  VPC_CIDR_BLOCK = 10.0.0.0/16 
  SUBNET_COUNT = 2
  SUBNET_NEWBITS_LIST = [12, 10]
  
  Subnet 1 CIDR = 10.0.0.0/28 (16+12 = 28)
  Subnet 2 CIDR = 10.0.0.17/26 (16+10 = 26)
  
> [!NOTE]
> Do not use this option if the VPC has subnets already

> [!CAUTION]
> Either one of the  arguments 'subnet_newbits_list' or 'cidr_blocks' must have data 

``` hcl
File : tc1_versions.tf in the root folder

provider "aws" {
  alias  = "home"
  region = var.wd_region["home_region"]

  default_tags {
    tags = local.tags
  }
}

File : tc1_versions.tf

locals {
  tags = {
    cost_center = "cost_center"
    project     = "project_name"
    change_id   = "change_id"
    mapid       = "abc-123"
    owner       = "platform-team"
  }
  dr_tags = {
    cost_center = "cost_center"
    project     = "project_name"
    change_id   = "change_id"
    mapid       = "abc-123"
    owner       = "platform-team"
  }
}

```

## Outputs

### Attribute : subnet_id
Displays the IDs of all the Subnet(s) created.

### Attribute : subnet_cidr_block
Displays the CIDR of all the Subnets(s) created.

### Attribute : subnet_az
Displays the AZ of all the Subnets(s) created.

### Attribute : subnet_arn
Displays the ARN of all the Subnets(s) created.

## How to execute pipeline to create VPC
Create a terrform file "tc7_vpcs.tf" or use the existing file "tc7_main.tf/tc7_vpcs.tf". Append the below terraform code snippet. replace "< name of my choice >" with the resource creation name you wish. 
Set the pipeline parameter as below and execute the pipeline

```hcl

module "< name of my choice >" {
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


Pipeline Parameter 
Target Name : module.< name of my choice >

```