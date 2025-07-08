output "primary_health_check_id" {
  value = aws_route53_health_check.primary.id
}

output "dr_health_check_id" {
  value = aws_route53_health_check.dr.id
}