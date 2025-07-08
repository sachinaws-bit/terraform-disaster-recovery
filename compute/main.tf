terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
      configuration_aliases = [aws.primary, aws.dr]
    }
  }
}

resource "aws_instance" "primary_instance" {
  provider               = aws.primary
  ami                    = "ami-05ffe3c48a9991133"  # Provided AMI for us-east-1
  instance_type          = "t3.micro"
  subnet_id              = element(var.primary_subnet_ids, 0)
  vpc_security_group_ids = [var.primary_security_group_id]

  tags = {
    Name = "Primary EC2 Instance"
  }
}

resource "aws_instance" "dr_instance" {
  provider               = aws.dr
  ami                    = "ami-0c803b171269e2d72"  # Provided AMI for us-east-2
  instance_type          = "t3.micro"
  subnet_id              = element(var.dr_subnet_ids, 0)
  vpc_security_group_ids = [var.dr_security_group_id]

  tags = {
    Name = "DR EC2 Instance (Warm Standby)"
  }
}