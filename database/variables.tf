variable "primary_subnet_ids" {
  description = "Subnet IDs for Primary Region"
  type        = list(string)
}

variable "dr_subnet_ids" {
  description = "Subnet IDs for DR Region"
  type        = list(string)
}