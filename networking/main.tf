terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
      configuration_aliases = [aws.primary, aws.dr]
    }
  }
}

resource "aws_vpc" "primary_vpc" {
  provider              = aws.primary
  cidr_block            = var.primary_vpc_cidr
  enable_dns_hostnames  = true
  enable_dns_support    = true
  tags = {
    Name = "Primary VPC"
  }
}

resource "aws_vpc" "dr_vpc" {
  provider              = aws.dr
  cidr_block            = var.dr_vpc_cidr
  enable_dns_hostnames  = true
  enable_dns_support    = true
  tags = {
    Name = "DR VPC"
  }
}

resource "aws_subnet" "primary_subnet_a" {
  provider                = aws.primary
  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = "192.168.0.0/17"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Primary Subnet A"
  }
}

resource "aws_subnet" "primary_subnet_b" {
  provider                = aws.primary
  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = "192.168.128.0/17"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "Primary Subnet B"
  }
}

resource "aws_subnet" "dr_subnet_a" {
  provider                = aws.dr
  vpc_id                  = aws_vpc.dr_vpc.id
  cidr_block              = "172.0.0.0/25"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "DR Subnet A"
  }
}

resource "aws_subnet" "dr_subnet_b" {
  provider                = aws.dr
  vpc_id                  = aws_vpc.dr_vpc.id
  cidr_block              = "172.0.0.128/25"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "DR Subnet B"
  }
}

resource "aws_internet_gateway" "primary_igw" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary_vpc.id
  tags = {
    Name = "Primary IGW"
  }
}

resource "aws_internet_gateway" "dr_igw" {
  provider = aws.dr
  vpc_id   = aws_vpc.dr_vpc.id
  tags = {
    Name = "DR IGW"
  }
}