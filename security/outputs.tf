output "primary_security_group_id" {
  value = aws_security_group.primary_sg.id
}

output "dr_security_group_id" {
  value = aws_security_group.dr_sg.id
}