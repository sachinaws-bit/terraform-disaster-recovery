variable "primary_subnet_ids" {
  description = "Subnet IDs for Primary Region"
  type        = list(string)
}

variable "dr_subnet_ids" {
  description = "Subnet IDs for DR Region"
  type        = list(string)
}

variable "primary_security_group_id" {
  description = "Security Group ID for Primary Region"
  type        = string
}

variable "dr_security_group_id" {
  description = "Security Group ID for DR Region"
  type        = string
}