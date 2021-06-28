
############################################################
# EasyPay - VPC
############################################################
resource "aws_vpc" "easypay_vpc" {
  cidr_block       	= var.vpc_cidr
  enable_dns_hostnames 	= true

  tags = {
    Name = "EasyPay-VPC"
  }
}

############################################################
# EasyPay - Gateway
############################################################
resource "aws_internet_gateway" "easypay_gateway" {
  vpc_id = aws_vpc.easypay_vpc.id

  tags = {
    Name = "EasyPay-MainGateway"
  }
}

############################################################
# EasyPay - Public Subnet
############################################################
resource "aws_subnet" "easypay_public" {

  vpc_id = aws_vpc.easypay_vpc.id

  cidr_block = var.public_subnet_cidr
  availability_zone = var.az

  map_public_ip_on_launch = true

  depends_on = [aws_internet_gateway.easypay_gateway]
  tags = {
    Name = "EasyPay-PublicSubnet"
  }
}


resource "aws_eip" "easypay_eip" {
    vpc      = true
    tags = {
     Name = "Easyoay - Public IP"
   }
}

resource "aws_nat_gateway" "easypay_nat" {
  allocation_id = aws_eip.easypay_eip.id
  subnet_id     = aws_subnet.easypay_public.id

  tags = {
    Name = "Easypay - NAT Gateway"
  }

  depends_on = [aws_internet_gateway.easypay_gateway]
}

#
# Public Routing Table
#

resource "aws_route_table" "easypay_public_rt" {
  vpc_id = aws_vpc.easypay_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.easypay_gateway.id
  }
  tags = {
    Name = "Easypay - Public RT"
  }
}

# Route table association with public subnets
resource "aws_route_table_association" "easypay_link" {
  subnet_id      = aws_subnet.easypay_public.id
  route_table_id = aws_route_table.easypay_public_rt.id
}


resource "aws_security_group" "easyoay_webservers" {
  name        = "Easypay - Security Group"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.easypay_vpc.id

  ## Allow traffic in for 
  ingress {
    from_port   = 30080
    to_port     = 30080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = “Web Application Traffic”
  }

  ## Open ports for Kubernetes 
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = “Kubernetes Control Traffic”
  }

  # Open ports for Weavenet
  ingress {
    from_port   = 6783
    to_port     = 6783
    protocol    = "all"
    cidr_blocks = [var.vpc_cidr]
    description = “Weavenet Control Traffic”
  }
  ingress {
    from_port   = 6784
    to_port     = 6784
    protocol    = "all"
    cidr_blocks = [var.vpc_cidr]
    description = “Weavenet Control Traffic”
  }
  # Allow Traffic out
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "Easypay - Security Group"
  }
}


