resource "aws_eip" "elastic-ip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.elastic-ip.id
  subnet_id     = var.subnet_id
  tags = {
    Name = var.nat_name
  }
}
