output "primary_alb_dns_name" {
  value = aws_lb.primary_alb.dns_name
}

output "dr_alb_dns_name" {
  value = aws_lb.dr_alb.dns_name
}