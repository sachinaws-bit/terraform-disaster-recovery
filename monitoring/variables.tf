variable "primary_instance_id" {
  description = "EC2 Instance ID in Primary Region"
  type        = string
}

variable "dr_instance_id" {
  description = "EC2 Instance ID in DR Region"
  type        = string
}