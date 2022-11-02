resource "aws_vpc" "vpc" {
  cidr_block = var.cidr
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge({
    Name                                        = "${var.prefix_name}-vpc"
    Environment                                 = var.env
  }, 
  var.common_tags,
  )
}
