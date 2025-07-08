variable "hosted_zone_id" {
  description = "Route 53 Hosted Zone ID"
  type        = string
}

variable "record_name" {
  description = "DNS record name (e.g. app.sachinawslearner.site)"
  type        = string
}

variable "primary_alb_dns_name" {
  description = "DNS name of Primary ALB"
  type        = string
}

variable "dr_alb_dns_name" {
  description = "DNS name of DR ALB"
  type        = string
}
