variable "environment" {
}

variable "aws_access_key" {
}

variable "aws_secret_key" {
}

variable "aws_public_zones" {
  type = list(string)
}

variable "aws_private_zones" {
  type = list(string)
}

variable "aws_region" {
}

variable "vpc_cidr" {
}

variable "numberofbits" {
}

variable "env_name" {
  type = string
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = merge(
    {
      "Name" = var.env_name
    },
  )
}

resource "aws_internet_gateway" "my_gw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = merge(
    {
      "Name" = var.env_name
    },
  )
}

/*
  Public Subnet
*/
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  count                   = length(var.aws_public_zones)
  cidr_block              = cidrsubnet(var.vpc_cidr, var.numberofbits, count.index)
  availability_zone       = var.aws_public_zones[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    {
      "Name" = format(
        "%v-public-%v",
        var.env_name,
        var.aws_public_zones[count.index],
      )
    },
  )
}

/*
  Allocate eip for nat 
*/

resource "aws_eip" "nat" {
  count = "1"
  vpc   = true
}

resource "aws_nat_gateway" "nat" {
  count         = "1"
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  depends_on = [
    aws_eip.nat,
    aws_internet_gateway.my_gw,
    aws_subnet.public_subnet,
  ]
  tags = merge(
    {
      "Name" = format("%v-nat-%v", var.env_name, var.aws_public_zones[count.index])
    },
  )
}

/*
  Private Subnet
*/
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  count  = length(var.aws_private_zones)
  cidr_block = cidrsubnet(
    var.vpc_cidr,
    var.numberofbits,
    count.index + length(var.aws_public_zones),
  )
  availability_zone       = var.aws_private_zones[count.index]
  map_public_ip_on_launch = false
  tags = merge(
    {
      "Name" = format(
        "%v-private-%v",
        var.env_name,
        var.aws_private_zones[count.index],
      )
    },
  )
}

############
## Routing (public subnets)
############
resource "aws_route_table" "route" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gw.id
  }
  tags = merge(
    {
      "Name" = format("%v-public-route-table", var.env_name)
    },
  )
}

resource "aws_route_table_association" "route" {
  count          = length(var.aws_public_zones)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.route.id
}

############
## Routing (private subnets)
############

resource "aws_route_table" "private_route" {
  count  = length(var.aws_private_zones)
  vpc_id = aws_vpc.my_vpc.id

  # Default route through NAT
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.nat.*.id, count.index)
  }
  tags = merge(
    {
      "Name" = format("%v-private-route-table", var.env_name)
    },
  )
}

resource "aws_route_table_association" "private_route" {
  count          = length(var.aws_private_zones)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private_route.*.id, count.index)
}

output "public_subnet_ids" {
  description = "list with ids of the public subnets"
  value       = aws_subnet.public_subnet.*.id
}

output "private_subnet_ids" {
  description = "list with ids of the private subnets"
  value       = aws_subnet.private_subnet.*.id
}

output "vpc_id" {
  description = "id of the vpc"
  value       = aws_vpc.my_vpc.id
}

output "az_public_id" {
  value = zipmap(var.aws_public_zones, aws_subnet.public_subnet.*.id)
}

output "az_private_id" {
  value = zipmap(var.aws_private_zones, aws_subnet.private_subnet.*.id)
}

