terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
      configuration_aliases = [aws.primary, aws.dr]
    }
  }
}

resource "aws_db_subnet_group" "primary_subnet_group" {
  provider   = aws.primary
  name       = "primary-db-subnet-group"
  subnet_ids = var.primary_subnet_ids

  tags = {
    Name = "Primary DB Subnet Group"
  }
}

resource "aws_db_subnet_group" "dr_subnet_group" {
  provider   = aws.dr
  name       = "dr-db-subnet-group"
  subnet_ids = var.dr_subnet_ids

  tags = {
    Name = "DR DB Subnet Group"
  }
}

resource "aws_db_instance" "primary_db" {
  provider                     = aws.primary
  identifier                   = "primary-db-instance"
  allocated_storage            = 20
  engine                       = "mysql"
  engine_version               = "8.0"
  instance_class               = "db.t3.micro"
  username                     = "admin"
  password                     = "password12345"
  skip_final_snapshot          = true
  db_subnet_group_name         = aws_db_subnet_group.primary_subnet_group.name
  publicly_accessible          = false
  backup_retention_period      = 1  

  tags = {
    Name = "Primary DB Instance"
  }
}

resource "aws_db_instance" "dr_read_replica" {
  provider                = aws.dr
  identifier              = "dr-db-read-replica"
  replicate_source_db     = aws_db_instance.primary_db.arn  
  instance_class          = "db.t3.micro"
  engine                  = "mysql"
  publicly_accessible     = false
  db_subnet_group_name    = aws_db_subnet_group.dr_subnet_group.name
  skip_final_snapshot     = true

  tags = {
    Name = "DR Read Replica"
  }
}