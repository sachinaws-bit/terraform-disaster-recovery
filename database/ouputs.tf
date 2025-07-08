output "primary_db_endpoint" {
  value = aws_db_instance.primary_db.endpoint
}

output "dr_read_replica_endpoint" {
  value = aws_db_instance.dr_read_replica.endpoint
}