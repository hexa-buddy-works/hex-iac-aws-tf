
# 1. Creation of VPC only


provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "My-VPC"
  }
}

output "vpc_id" {
  value = aws_vpc.my_vpc.id
}


# 2. VPC + Private Subnet


resource "aws_subnet" "private_subnet" {
  count = var.scenario == "single" ? 1 : 0

  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Private-Subnet"
  }
}

output "single_private_subnet_id" {
  value = aws_subnet.private_subnet[*].id
}


# 3. VPC + Private Subnet in Multiple AZs


resource "aws_subnet" "multi_az_subnet" {
  count = var.scenario == "multi_az" ? 2 : 0

  vpc_id = aws_vpc.my_vpc.id

  cidr_block = element(
    ["10.0.1.0/24", "10.0.2.0/24"],
    count.index
  )

  availability_zone = element(
    ["ap-south-1a", "ap-south-1b"],
    count.index
  )

  tags = {
    Name = "Private-Subnet-${count.index + 1}"
  }
}

output "multi_az_private_subnet_ids" {
  value = aws_subnet.multi_az_subnet[*].id
}


# 4. VPC + Private and Public Subnets


provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block           = var.landing_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project_name}-${var.environment}-private-subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-public-rtb"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-${var.environment}-private-rtb"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}


# 5. VPC + Private subnets in multiple AZs and Public in multiple AZs


resource "aws_subnet" "public" {
  count = var.az_count

  vpc_id                  = aws_vpc.main.id
  availability_zone       = var.azs[count.index]
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "public-${count.index + 1}"
    Tier = "public"
  }
}

resource "aws_subnet" "private_app" {
  count             = var.az_count

  vpc_id            = aws_vpc.main.id
  availability_zone = var.azs[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 10)

  tags = {
    Name = "private-app-${count.index + 1}"
    Tier = "application"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = var.az_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private_app" {
  count  = var.az_count
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-app-rt-${count.index + 1}"
  }
}

resource "aws_route_table_association" "private_app" {
  count          = var.az_count
  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.private_app[count.index].id
}


# 6. VPC + Transit Gateway Attachment


resource "aws_ec2_transit_gateway" "main" {
  description = "Transit Gateway for ${var.project_name}-${var.environment}"

  tags = {
    Name        = "${var.project_name}-${var.environment}-tgw"
    Environment = var.environment
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  vpc_id             = aws_vpc.main.id
  subnet_ids         = [aws_subnet.private.id, aws_subnet.public.id]
  transit_gateway_id = aws_ec2_transit_gateway.main.id

  tags = {
    Name = "${var.project_name}-${var.environment}-tgw-attachment"
  }
}


# 7. VPC + Gateway Load Balancers


resource "aws_lb" "gwlb" {
  name               = "inspection-gwlb"
  load_balancer_type = "gateway"
  subnets            = aws_subnet.inspection[*].id

  tags = {
    Name = "inspection-gwlb"
  }
}

resource "aws_lb_target_group" "firewalls" {
  name        = var.name
  port        = 6081
  protocol    = "GENEVE"
  target_type = var.target_type
  vpc_id      = aws_vpc.main.id

  health_check {
    enabled  = true
    protocol = "TCP"
    port     = "80"
  }

  tags = {
    Name = var.name
  }
}

resource "aws_lb_listener" "geneve" {
  load_balancer_arn = aws_lb.gwlb.arn
  port              = 6081
  protocol          = "GENEVE"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.firewalls.arn
  }
}

resource "aws_vpc_endpoint_service" "gwlb_service" {
  acceptance_required        = false
  gateway_load_balancer_arns = [aws_lb.gwlb.arn]

  tags = {
    Name = "inspection-service"
  }
}


# 8. VPC + NLB (With1,2 and 3 public Ips)


resource "aws_subnet" "nlb_public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.10.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-nlb-public-1"
  }
}

resource "aws_subnet" "nlb_public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.11.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-nlb-public-2"
  }
}

resource "aws_subnet" "nlb_public_3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.12.0/24"
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-nlb-public-3"
  }
}

resource "aws_lb" "public_nlb" {
  name               = "${var.project_name}-${var.environment}-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.nlb_public_1.id, aws_subnet.nlb_public_2.id, aws_subnet.nlb_public_3.id]

  enable_cross_zone_load_balancing = true

  tags = {
    Name = "${var.project_name}-${var.environment}-nlb"
  }
}

resource "aws_lb_target_group" "main" {
  name        = "${var.project_name}-${var.environment}-tg"
  port        = 80
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id

  health_check {
    port     = 80
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.public_nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

# 9. VPC + private subnets in every AZs


locals {
  az_index = {
    for index, az in data.aws_availability_zones.available.names :
    az => index
  }
}

resource "aws_subnet" "private" {
  for_each                        = local.az_index
  vpc_id                          = aws_vpc.main.id
  availability_zone               = each.key
  cidr_block                      = cidrsubnet(var.vpc_cidr, var.private_subnet_newbits, each.value)
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = false

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-private-${each.key}"
    Type = "Private"
    AZ   = each.key
  })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-private-rt"
    Type = "Private"
  })
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}


# 10. VPC + private subnets in 3 AZs


resource "aws_subnet" "private" {
  count = var.az_count

  vpc_id                          = aws_vpc.main.id
  cidr_block                      = var.private_subnet_cidrs[count.index]
  availability_zone               = local.availability_zones[count.index]
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = false

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-private-${count.index + 1}"
    Tier = "Private"
  })
}

resource "aws_route_table" "private" {
  count  = var.az_count
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-private-rt-${count.index + 1}"
  })
}

resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}