variable "primary_region" {
  description = "Primary AWS Region"
  default     = "us-east-1"
}

variable "dr_region" {
  description = "Disaster Recovery AWS Region"
  default     = "us-east-2"
}

variable "primary_vpc_cidr" {
  description = "CIDR block for Primary VPC"
  default     = "192.168.0.0/16"
}

variable "dr_vpc_cidr" {
  description = "CIDR block for DR VPC"
  default     = "172.0.0.0/24"
}

variable "route53_zone_id" {
  description = "Route53 Hosted Zone ID"
  default     = "Z0122406IWOW2A6B6FJY"
}
variable "hosted_zone_id" {
  description = "Route 53 Hosted Zone ID for sachinawslearner.site"
  type        = string
}

variable "record_name" {
  description = "DNS record name for application"
  type        = string
  default     = "app.sachinawslearner.site"
}