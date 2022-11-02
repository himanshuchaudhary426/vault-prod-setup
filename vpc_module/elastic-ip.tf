resource "aws_eip" "eip" {
  tags = merge({
    Name        = "${var.prefix_name}-public-rt"
    Environment = var.env
  }, 
  var.common_tags,
  )
}