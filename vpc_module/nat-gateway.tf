resource "aws_nat_gateway" "ng" {
  
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnet.*.id[1]

  tags = merge({
    Name        = "${var.prefix_name}-public-rt"
    Environment = var.env
  }, 
  var.common_tags,
  )
}
