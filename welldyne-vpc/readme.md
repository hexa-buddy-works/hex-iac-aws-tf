# Provision VPC(s) 
This module creates VPC(s) in AWS

## Environments
This terraform module developed using terraform version 1.16.4 and AWS provider version 6.70.0

## Module Information
Multiple VPCs can be created using this module. The file sample.txt helps to form the data to create VPC(s). This module is written as part of Landingzone implementation and migration activity


## Usage

```hcl

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


```

## Inputs

### Argument : vpc_count 
Number of VPCs to be created. Value cannot exceed 5

### Argument : prov_region  - provided region
This is the region where the VPC to be provisioned (home or dr)

### Argument : cidr_block
The CIDR private ip block for the VPC. The VPC CIDR block must reside within the Class A (10.0.0.0/16) private IP range

### Argument : instance_tenancy
Tenancy of instances to spin up within VPC

### Argument : prov_tags - provided tags
To add custom tags. The calling script must pass default tags. The default tags contain the madatory tags like mapid, costcenter etc,.

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

### Attribute : vpc_id
Displays the IDs of all the VPC(s) created.

### Attribute : vpc_cidr_block
Displays the CIDRs of all the VPC(s) created.

### Attribute : vpc_arn
Displays the ARNs of all the VPC(s) created.

### Attribute : region
Displays the region where the VPC(s) created.

### Attribute : instance_tenancy
Displays the tenancy used to createinstances inside the VPC(s) created.

### Attribute : enable_dns_support
Displays the DNS support of the VPC(s) created.

## How to execute pipeline to create VPC
Create a terrform file "tc7_vpcs.tf" or use the existing file "tc7_main.tf/tc7_vpcs.tf". Append the below terraform code snippet. replace "< name of my choice >" with the resource creation name you wish. 
Set the pipeline parameter as below and execute the pipeline

```hcl

module "< name of my choice >" {
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

Pipeline Parameter 
Target Name : module.< name of my choice >

```