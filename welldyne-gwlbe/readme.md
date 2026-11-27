# Provision Subnet(s) 
This module creates VPC(s) in AWS

## Environments
This terraform module developed using terraform version 1.16.4 and AWS provider version 6.70.0

## Module Information



## Usage

```hcl




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

### Attribute : 

## How to execute pipeline to create VPC
Create a terrform file "tc7_vpcs.tf" or use the existing file "tc7_main.tf/tc7_vpcs.tf". Append the below terraform code snippet. replace "< name of my choice >" with the resource creation name you wish. 
Set the pipeline parameter as below and execute the pipeline

```hcl



Pipeline Parameter 
Target Name : module.< name of my choice >

```