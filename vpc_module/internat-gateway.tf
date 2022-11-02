resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = merge({
    Name        = "${var.prefix_name}-public-rt"
    Environment = var.env
  }, 
  var.common_tags,
  )
}