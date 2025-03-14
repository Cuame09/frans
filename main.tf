# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}




resource "aws_vpc" "frans" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "frans"
    Env  = "Production"
  }
}

# 2 Public subnets

resource "aws_subnet" "frans-pub-sub1" {
  vpc_id            = awsns_vpc.frans.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "TERRA"
  }
}

resource "aws_subnet" "frans-pub-sub2" {
  vpc_id                  = aws_vpc.frans.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "frans"
  }
}

# 2 Private subnets

resource "aws_subnet" "frans-priv-sub1" {
  vpc_id     = aws_vpc.frans.id
  cidr_block = "10.0.3.0/24"


  tags = {
    Name = "frans"
  }
}

resource "aws_subnet" "frans-priv-sub2" {
  vpc_id     = aws_vpc.fra.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "frans"
  }
}

# CREATING INTERNET GATEWAY

resource "aws_internet_gateway" "frans-igw" {
  vpc_id = aws_vpc.frans.id

  tags = {
    Name = "frans"
  }
}

# CREATING EIPs 

resource "aws_eip" "nat" {
  depends_on = [aws_internet_gateway.frans-igw]
}

#CREATING NAT GATEWAY

resource "aws_nat_gateway" "frans-ngw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.frans-pub-sub1.id

  tags = {
    Name = "frans-ngw"
  }

}

# TWO ROUTE TABLES FOR THE NETWORK

resource "aws_route_table" "frans-pub-rt" {
  vpc_id = aws_vpc.frans.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.frans-igw.id
  }

  tags = {
    Name = "frans-pub-rt"
  }
}

resource "aws_route_table" "frans-priv-rt" {
  vpc_id = aws_vpc.frans.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.frans-ngw.id
  }

  tags = {
    Name = "frans-priv-rt"
  }
}

# ROUTE TABLE ASSOCIATION

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.frans-pub-sub1.id
  route_table_id = aws_route_table.frans-pub-rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.frans-pub-sub2.id
  route_table_id = aws_route_table.frans-priv-rt.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.frans-priv-sub1.id
  route_table_id = aws_route_table.frans-priv-rt.id
}

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.frans-priv-sub2.id
  route_table_id = aws_route_table.frans-priv-rt.id
}
