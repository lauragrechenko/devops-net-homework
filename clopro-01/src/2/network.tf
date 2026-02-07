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
resource "aws_eip" "nat" {
  count  = 1
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "${local.name_prefix}-nat-gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.this]
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
