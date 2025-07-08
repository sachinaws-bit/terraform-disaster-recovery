output "primary_vpc_id" {
  value = module.networking.primary_vpc_id
}

output "dr_vpc_id" {
  value = module.networking.dr_vpc_id
}

output "primary_subnet_ids" {
  value = module.networking.primary_subnet_ids
}

output "dr_subnet_ids" {
  value = module.networking.dr_subnet_ids
}

output "primary_security_group_id" {
  value = module.security.primary_security_group_id
}

output "dr_security_group_id" {
  value = module.security.dr_security_group_id
}