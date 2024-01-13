resource "aws_vpc" "spitlog_net" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    App = "spitlog"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.spitlog_net.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false

  tags = {
    App = "spitlog"
  }
}

resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = aws_vpc.spitlog_net.id

  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    App = "spitlog"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.private_subnet.id
}

resource "aws_eip" "eip" {
  tags = {
    App = "spitlog"
  }
}

resource "aws_security_group" "spitlog_sg" {
  vpc_id = aws_vpc.spitlog_net.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    App = "spitlog"
  }
}
