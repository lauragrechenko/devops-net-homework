resource "aws_vpc" "this" {

  cidr_block = var.vpc_cidr

  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.cidr_public

  availability_zone = var.default_availability_zone

  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "${local.name_prefix}-subnet-public"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.cidr_public_2

  availability_zone = var.availability_zone_2

  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "${local.name_prefix}-subnet-public-2"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${local.name_prefix}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${local.name_prefix}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# ---------------

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "${local.name_prefix}-nat-gw"
  }

  depends_on = [aws_internet_gateway.this]
}

# ---------------

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.cidr_private

  availability_zone = var.default_availability_zone

  map_public_ip_on_launch = var.map_private_ip_on_launch

  tags = {
    Name = "${local.name_prefix}-subnet-private"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "${local.name_prefix}-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
