# Create a VPC
resource "aws_vpc" "spitlog_net" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    App = "spitlog"
  }
}

# Create an internet gateway for the VPC
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.spitlog_net.id

  tags = {
    App = "spitlog"
  }
}

# Create an Elastic IP for the Nat Gateway
resource "aws_eip" "eip" {
  tags = {
    App = "spitlog"
  }
}

# Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.spitlog_net.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    App = "spitlog"
  }
}

# Create a private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.spitlog_net.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false

  tags = {
    App = "spitlog"
  }
}

# Create a public NAT Gateway that is associated with the Elastic IP and the public subnet
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet.id
}

# Create a route table for the public subnet allowing local communication 
# and declaring any other traffic to be directed to the Internet Gateway
resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.spitlog_net.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

# Create a route table for the private subnet allowing local communication
# and declaring any other traffic should be directed to the NAT Gateway in the public subnet
resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = aws_vpc.spitlog_net.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    App = "spitlog"
  }
}

# Associate the public subnet route table to the public subnet
resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

# Associate the private subnet route table to the private subnet
resource "aws_route_table_association" "private_subnet" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_subnet_route_table.id
}

# resource "aws_security_group" "spitlog_sg" {
#   vpc_id = aws_vpc.spitlog_net.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     App = "spitlog"
#   }
# }
