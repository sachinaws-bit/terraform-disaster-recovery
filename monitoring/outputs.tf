output "primary_cpu_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.primary_cpu_alarm.arn
}

output "dr_cpu_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.dr_cpu_alarm.arn
}