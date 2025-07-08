output "primary_instance_id" {
  value = aws_instance.primary_instance.id
}

output "dr_instance_id" {
  value = aws_instance.dr_instance.id
}