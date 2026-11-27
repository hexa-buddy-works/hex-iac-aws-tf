# Provision Load Balancer(s) of type Network 
This module creates Network Load Balancer(s) in AWS

## Environments
This terraform module developed using terraform version 1.16.4 and AWS provider version 6.70.0

## Module Information
Multiple NLB(s) can be created using this module. The file sample.txt helps to form the data to create NLB(s). This module is written as part of Landingzone implementation and migration activity


## Usage

```hcl
module "dev_nlb" {
  source      = "./welldyne-nlb"
  prov_region = "home"
  prov_tags = {
    Name = "value"
  }
  nlb_count = 2
  vpc_id = "value"

  nlbs = [
    {
      name = "nlb1"
      nlb_internal = true
      subnet_mappings = [ 
      {
        # allocation_id = "value" -----------  Not required for internal NLBs
        private_ipv4_address = "10.0.1.10"
        subnet_id = "value1"
      },
      {
        private_ipv4_address = "10.0.2.10"
        subnet_id = "value2"
      }
      ]
    },
    {
      name = "nlb2"
      nlb_internal = true
      subnet_mappings = [ 
      {
        # allocation_id = "value" -----------  Not required for internal NLBs
        private_ipv4_address = "10.1.1.10"
        subnet_id = "value1"
      },
      {
        private_ipv4_address = "10.1.2.10"
        subnet_id = "value2"
      }
      ]
    }
  ]

  nlb_target_groups = [
    {
      name = "tg1"
      port = 80
      protocol = "TCP"
      target_type = "ip"
      health_check_protocol = "TCP"
      health_check_port = "80"
      weight = 50
    }, 
    {
      name = "tg2"
      port = 80
      protocol = "TCP"
      target_type = "ip"
      health_check_protocol = "TCP"
      health_check_port = "80"
      weight = 50
    },
    {
      name = "tg3"
      port = 8080
      protocol = "TCP"
      target_type = "ip"
      health_check_protocol = "TCP"
      health_check_port = "8080"
      weight = 100
    },
    {
      name = "tg4"
      port = 443
      protocol = "TCP"
      target_type = "ip"
      health_check_protocol = "TCP"
      health_check_port = "443"
      weight = 100
    }
  ]

  nlb_listeners = [
    {
      nlb_name = "nlb1"
      port = 80
      protocol = "TCP"
      target_group_names = [ "tg1", "tg2" ]
    },
    {
      nlb_name = "nlb1"
      port = 8080
      protocol = "TCP"
      target_group_names = [ "tg3" ]
    },
    {
      nlb_name = "nlb2"
      port = 443
      protocol = "TCP"
      target_group_names = [ "tg4" ]
    }
  ]

  nlb_target_group_attachments = [
    {
      target_group_name = "tg1"
      target_id = "instance1"
      target_port = 80
    },
    {
      target_group_name = "tg1"
      target_id = "instance2"
      target_port = 80
    },
    {
      target_group_name = "tg1"
      target_id = "instance3"
      target_port = 80
    },
    {
      target_group_name = "tg1"
      target_id = "lambda_arn1"
      target_port = 8080
    },
    {
      target_group_name = "tg1"
      target_id = "lambda_arn2"
      target_port = 8080
    },
    {
      target_group_name = "tg1"
      target_id = "alb_arn1"
      target_port = 443
    }
  ]
}

```

## Inputs

### Argument : nlb_count (number)
Number of NLBs to be created.

### Argument : prov_region (string - home/dr) - provided region
This is the region where the NLB to be provisioned (home or dr)

### Argument : vpc_id (string)
The VPC Id where the NLB to be created

### Arguments : nlb_ip_address_type
The type of the IP address (IPV4/DUALSTACK)

### Argument : nlbs
The network load balancer arguments. Get details from sample.txt

### Arguments : nlb_target_groups
The network load balancer's target groups.  Get details from sample.txt

### Arguments : nlb_listeners
The network load balancer's listeners.  Get details from sample.txt

### Arguments : nlb_target_group_attachments
The network load balancer's target groups attachment.  Get details from sample.txt

## Outputs

### Attribute : nlb_arns
The ARN of the NLB(s)

### Attribute : nlb_names
The NAME of the NLB(s)

### Attribute : nlb_target_groups_arn
The ARN of the Target Groups 

### Attribute : nlb_listener_arn
The ARN of the NLB Listener(s)

## How to execute pipeline to create  Network Load Balancer(s)
Create a terrform file "tc7_nlbs.tf" or use the existing file "tc7_main.tf/tc7_nlbs.tf". Append the below terraform code snippet. replace "< name of my choice >" with the resource creation name you wish. 
Set the pipeline parameter as below and execute the pipeline

```hcl
module "< name of my choice >" {
  source      = "./welldyne-nlb"
  prov_region = "home"
  prov_tags = {
    Name = "value"
  }
  nlb_count = 2
  vpc_id = "value"

  nlbs = [
    {
      name = "nlb1"
      nlb_internal = true
      subnet_mappings = [ 
      {
        # allocation_id = "value" -----------  Not required for internal NLBs
        private_ipv4_address = "10.0.1.10"
        subnet_id = "value1"
      },
      {
        private_ipv4_address = "10.0.2.10"
        subnet_id = "value2"
      }
      ]
    },
    {
      name = "nlb2"
      nlb_internal = true
      subnet_mappings = [ 
      {
        # allocation_id = "value" -----------  Not required for internal NLBs
        private_ipv4_address = "10.1.1.10"
        subnet_id = "value1"
      },
      {
        private_ipv4_address = "10.1.2.10"
        subnet_id = "value2"
      }
      ]
    }
  ]

  nlb_target_groups = [
    {
      name = "tg1"
      port = 80
      protocol = "TCP"
      target_type = "ip"
      health_check_protocol = "TCP"
      health_check_port = "80"
      weight = 50
    }, 
    {
      name = "tg2"
      port = 80
      protocol = "TCP"
      target_type = "ip"
      health_check_protocol = "TCP"
      health_check_port = "80"
      weight = 50
    },
    {
      name = "tg3"
      port = 8080
      protocol = "TCP"
      target_type = "ip"
      health_check_protocol = "TCP"
      health_check_port = "8080"
      weight = 100
    },
    {
      name = "tg4"
      port = 443
      protocol = "TCP"
      target_type = "ip"
      health_check_protocol = "TCP"
      health_check_port = "443"
      weight = 100
    }
  ]

  nlb_listeners = [
    {
      nlb_name = "nlb1"
      port = 80
      protocol = "TCP"
      target_group_names = [ "tg1", "tg2" ]
    },
    {
      nlb_name = "nlb1"
      port = 8080
      protocol = "TCP"
      target_group_names = [ "tg3" ]
    },
    {
      nlb_name = "nlb2"
      port = 443
      protocol = "TCP"
      target_group_names = [ "tg4" ]
    }
  ]

  nlb_target_group_attachments = [
    {
      target_group_name = "tg1"
      target_id = "instance1"
      target_port = 80
    },
    {
      target_group_name = "tg1"
      target_id = "instance2"
      target_port = 80
    },
    {
      target_group_name = "tg1"
      target_id = "instance3"
      target_port = 80
    },
    {
      target_group_name = "tg1"
      target_id = "lambda_arn1"
      target_port = 8080
    },
    {
      target_group_name = "tg1"
      target_id = "lambda_arn2"
      target_port = 8080
    },
    {
      target_group_name = "tg1"
      target_id = "alb_arn1"
      target_port = 443
    }
  ]
}


Pipeline Parameter 
Target Name : module.< name of my choice >

```