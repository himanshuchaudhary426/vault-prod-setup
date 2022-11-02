resource "aws_subnet" "public-subnet" {
  count                   = 3

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.100.${count.index}.0/24"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true


  tags = merge({
    Name                                        = "${var.prefix_name}-public-subnet"
    Environment                                 = var.env
  }, var.common_tags)
}

resource "aws_subnet" "private-subnet" {
  count             = 3

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.100.${count.index + 3}.0/24"
  vpc_id            = aws_vpc.vpc.id

  tags = merge({
    Name                                        = "${var.prefix_name}-private-subnet"
    Environment                                 = var.env
  }, var.common_tags)
}