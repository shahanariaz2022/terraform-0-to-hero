//Create Vpc
resource "aws_vpc" "custom_vpc" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc_automation"
  }
}

// Create Subnets(2 public subnets and 2 private subnets)
resource "aws_subnet" "Pub_subnet" {
    vpc_id = aws_vpc.custom_vpc.id
    count = length(var.Availability_zones)
    cidr_block = cidrsubnet(aws_vpc.custom_vpc.cidr_block, 8, count.index+1)
    availability_zone = element(var.Availability_zones, count.index)
    tags = {
      Name = "Public_subnet ${count.index+1}"
    }
}

/* 
For Example : 10.0.0.0/16
cidrsubnet(10.0.0.0/16, 8, 0+1) --> 10.0.1.0/24
cidrsubnet(10.0.0.0/16, 8, 0+1) --> 10.0.2.0/24
*/

resource "aws_subnet" "Pri_subnet" {
    vpc_id = aws_vpc.custom_vpc.id
    count = length(var.Availability_zones)
    cidr_block = cidrsubnet(aws_vpc.custom_vpc.cidr_block, 8, count.index+3)
    availability_zone = element(var.Availability_zones, count.index)
    tags = {
      Name = "Private_subnet ${count.index+1}"
    }
}

// Create Internet Gateway

resource "aws_internet_gateway" "my_IGW" {
    vpc_id = aws_vpc.custom_vpc.id
    tags = {
      Name = "custom_vpc_IGW"
    }
}

// Create Route Table for Public Subnet
resource "aws_route_table" "my_pub_RT" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_IGW.id
  }
  tags = {
    Name = "public_RouteTable"
  }
}

//Create association between route table and Internet gateway

resource "aws_route_table_association" "pub_sub_association" {
    route_table_id = aws_route_table.my_pub_RT.id
    count = length(var.Availability_zones)
    subnet_id = element(aws_subnet.Pub_subnet[*].id, count.index)
}

//Create Elastic IP

resource "aws_eip" "my_eip" {
    domain = "vpc"
    depends_on = [aws_internet_gateway.my_IGW]
  
}

// Create NAT Gateway to one of the private subnets

resource "aws_nat_gateway" "my_natgateway" {
  subnet_id = element(aws_subnet.Pri_subnet[*].id, 0)
  allocation_id = aws_eip.my_eip.id
  depends_on = [aws_internet_gateway.my_IGW]
  tags = {
    Name = "my_natgateway"
  }
}

//Create RT for private subnet

resource "aws_route_table" "my_pri_RT" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_natgateway.id
  }
  tags = {
    Name = "private_RouteTable"
  }
}

// Create Route Table association with private subnet
resource "aws_route_table_association" "pri_sub_association" {
    route_table_id = aws_route_table.my_pri_RT.id
    count = length(var.Availability_zones)
    subnet_id = element(aws_subnet.Pri_subnet[*].id, count.index)
}
