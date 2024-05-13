#1 Create a VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-${var.cluster_name}"
  }
}

#2 Create an IG
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "igw-${var.cluster_name}"
  }
}

#3 Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.public_subnets, count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.cluster_name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.private_subnets, count.index)
  map_public_ip_on_launch = false
  availability_zone       = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.cluster_name}-private-subnet-${count.index + 1}"
  }
}


#4 Route tables and association
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.cluster_name}-public-rt"
  }
}

resource "aws_route_table_association" "this" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.this.id
}