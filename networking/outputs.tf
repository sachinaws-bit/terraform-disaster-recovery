output "primary_vpc_id" {
  value = aws_vpc.primary_vpc.id
}

output "dr_vpc_id" {
  value = aws_vpc.dr_vpc.id
}

output "primary_subnet_ids" {
  value = [
    aws_subnet.primary_subnet_a.id,
    aws_subnet.primary_subnet_b.id
  ]
}

output "dr_subnet_ids" {
  value = [
    aws_subnet.dr_subnet_a.id,
    aws_subnet.dr_subnet_b.id
  ]
}