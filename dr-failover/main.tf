resource "aws_route53_health_check" "primary" {
  provider = aws.primary
  fqdn     = var.primary_alb_dns_name
  port     = 443
  type     = "HTTPS"
  resource_path = "/"
  failure_threshold = 3
  request_interval  = 30
}

resource "aws_route53_health_check" "dr" {
  provider = aws.primary
  fqdn     = var.dr_alb_dns_name
  port     = 443
  type     = "HTTPS"
  resource_path = "/"
  failure_threshold = 3
  request_interval  = 30
}

resource "aws_route53_record" "primary_dns" {
  provider = aws.primary
  zone_id  = var.hosted_zone_id
  name     = var.record_name
  type     = "A"

  alias {
    name                   = var.primary_alb_dns_name
    zone_id                = "Z35SXDOTRQ7X7K"
    evaluate_target_health = true
  }

  set_identifier  = "Primary"
  health_check_id = aws_route53_health_check.primary.id

  failover_routing_policy {
    type = "PRIMARY"
  }
}

resource "aws_route53_record" "dr_dns" {
  provider = aws.primary
  zone_id  = var.hosted_zone_id
  name     = var.record_name
  type     = "A"

  alias {
    name                   = var.dr_alb_dns_name
    zone_id                = "Z3AADJGX6KTTL2"
    evaluate_target_health = false
  }

  set_identifier  = "DR"
  health_check_id = aws_route53_health_check.dr.id

  failover_routing_policy {
    type = "SECONDARY"
  }
}