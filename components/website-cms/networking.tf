###
# AWS VPC
###

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "website-cms" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name       = var.product_name
    CostCenter = var.product_name
  }
}

###
# AWS Internet Gateway
###

resource "aws_internet_gateway" "website-cms" {
  vpc_id = aws_vpc.website-cms.id

  tags = {
    Name       = var.product_name
    CostCenter = var.product_name
  }
}

resource "aws_nat_gateway" "gw" {
  count       = 2
  subnet_id     = aws_subnet.website-cms-public[count.index].id

  depends_on = [aws_internet_gateway.website-cms]
  allocation_id = aws_eip.website-cms.*.id[count.index]
}

###
# AWS Subnets
###

resource "aws_subnet" "website-cms-private" {
  count = 2

  vpc_id            = aws_vpc.website-cms.id
  cidr_block        = cidrsubnet("10.0.0.0/16", 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name       = "Private Subnet 0${count.index + 1}"
    CostCenter = "website-cms"
    Access     = "private"
  }
}

resource "aws_subnet" "website-cms-public" {
  count = 2

  vpc_id            = aws_vpc.website-cms.id
  cidr_block        = cidrsubnet("10.0.0.0/16", 8, count.index + 3)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name       = "Public Subnet 0${count.index + 1}"
    CostCenter = "website-cms"
    Access     = "public"
  }
}

###
# AWS Routes
###

resource "aws_route_table" "website-cms-public_subnet" {
  vpc_id = aws_vpc.website-cms.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.website-cms.id
  }

  tags = {
    Name       = "Public Subnet Route Table"
    CostCenter = var.product_name
  }
}

resource "aws_route_table_association" "website-cms" {
  count = 2

  subnet_id      = aws_subnet.website-cms-public.*.id[count.index]
  route_table_id = aws_route_table.website-cms-public_subnet.id
}

resource "aws_route_table" "website-cms-private_subnet" {
  count = 3

  vpc_id = aws_vpc.website-cms.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.*.id[count.index]
  }

  tags = {
    Name       = var.product_name
    CostCenter = var.product_name
  }
}

resource "aws_route_table_association" "website-cms-private" {
  count = 3

  subnet_id      = aws_subnet.website-cms-private.*.id[count.index]
  route_table_id = aws_route_table.website-cms-private_subnet.*.id[count.index]
}


###
# AWS Network ACL
###

resource "aws_default_network_acl" "website-cms" {
  default_network_acl_id = aws_vpc.website-cms.default_network_acl_id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 3389
    to_port    = 3389
  }

  ingress {
    protocol   = -1
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  // See https://www.terraform.io/docs/providers/aws/r/default_network_acl.html#managing-subnets-in-the-default-network-acl
  lifecycle {
    ignore_changes = [subnet_ids]
  }

  tags = {
    CostCenter = var.product_name
  }
}

###
# AWS EIP
###

resource "aws_eip" "website-cms" {	
  count = 2
  depends_on = [aws_internet_gateway.website-cms]	

  vpc = true	

  tags = {	
    Name       = var.product_name	
    CostCenter = var.product_name	
  }	
}