terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
      configuration_aliases = [aws.primary, aws.dr]
    }
  }
}

# CloudWatch Alarm for Primary Region EC2 CPU Utilization
resource "aws_cloudwatch_metric_alarm" "primary_cpu_alarm" {
  provider          = aws.primary
  alarm_name        = "Primary-CPU-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 2
  metric_name       = "CPUUtilization"
  namespace         = "AWS/EC2"
  period            = 300
  statistic         = "Average"
  threshold         = 80
  alarm_description = "Alarm when Primary EC2 CPU exceeds 80%"
  dimensions = {
    InstanceId = var.primary_instance_id
  }
}

# CloudWatch Alarm for DR Region EC2 CPU Utilization
resource "aws_cloudwatch_metric_alarm" "dr_cpu_alarm" {
  provider          = aws.dr
  alarm_name        = "DR-CPU-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 2
  metric_name       = "CPUUtilization"
  namespace         = "AWS/EC2"
  period            = 300
  statistic         = "Average"
  threshold         = 80
  alarm_description = "Alarm when DR EC2 CPU exceeds 80%"
  dimensions = {
    InstanceId = var.dr_instance_id
  }
}