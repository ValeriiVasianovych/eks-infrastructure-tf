
resource "aws_eip" "nat" {
  count = length(aws_subnet.private_subnets)
  tags = {
    Name = "${var.prefix_name}-eip-${count.index + 1}-${var.env}"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.private_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id
  tags = {
    Name = "${var.prefix_name}-nat-gw-${count.index + 1}-${var.env}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name                              = "${var.prefix_name}-private-subnet-${count.index + 1}-${var.env}"
    CIDR                              = var.private_subnet_cidrs[count.index]
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_route_table" "private_subnets" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }
  tags = {
    Name = "${var.prefix_name}-private-subnet-${count.index + 1}-${var.env}"
  }
}

resource "aws_route_table_association" "private_routes" {
  count          = length(var.private_subnet_cidrs)
  route_table_id = aws_route_table.private_subnets[count.index].id
  subnet_id      = aws_subnet.private_subnets[count.index].id
}
