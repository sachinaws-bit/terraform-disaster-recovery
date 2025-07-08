terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
      configuration_aliases = [aws.primary, aws.dr]
    }
  }
}

resource "aws_lb" "primary_alb" {
  provider           = aws.primary
  name               = "primary-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.primary_security_group_id]
  subnets            = var.primary_subnet_ids

  tags = {
    Name = "Primary ALB"
  }
}

resource "aws_lb" "dr_alb" {
  provider           = aws.dr
  name               = "dr-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.dr_security_group_id]
  subnets            = var.dr_subnet_ids

  tags = {
    Name = "DR ALB"
  }
}

resource "aws_lb_listener" "primary_listener" {
  provider          = aws.primary
  load_balancer_arn = aws_lb.primary_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Primary ALB Response"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "dr_listener" {
  provider          = aws.dr
  load_balancer_arn = aws_lb.dr_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "DR ALB Response"
      status_code  = "200"
    }
  }
}