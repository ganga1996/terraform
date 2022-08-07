provider "aws" {
  region = "ap-south-1"
  
}
resource "aws_vpc" "main" {
  cidr_block       = "10.1.0.0/16"
  instance_tenancy = "default"
  
  tags = {
    Name = "ganga-vpc"
    terraform = "true"
  }
}

resource "aws_subnet" "public-1a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "ganga-public-1a"
    terraform = "true"
  }
}

resource "aws_subnet" "public-1b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "ganga-public-1b"
    terraform = "true"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
    terraform = "true"
    created_by = "ganga"
  }
}

resource "aws_route_table" "ganga-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" = "pub-rt"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public-1a.id
  route_table_id = aws_route_table.ganga-rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public-1b.id
  route_table_id = aws_route_table.ganga-rt.id
}
