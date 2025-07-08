module "networking" {
  source           = "./networking"
  primary_vpc_cidr = var.primary_vpc_cidr
  dr_vpc_cidr      = var.dr_vpc_cidr

  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
  }
}

module "security" {
  source         = "./security"
  primary_vpc_id = module.networking.primary_vpc_id
  dr_vpc_id      = module.networking.dr_vpc_id

  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
  }
}

module "compute" {
  source                    = "./compute"
  primary_subnet_ids        = module.networking.primary_subnet_ids
  dr_subnet_ids             = module.networking.dr_subnet_ids
  primary_security_group_id = module.security.primary_security_group_id
  dr_security_group_id      = module.security.dr_security_group_id

  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
  }
}

module "load_balancer" {
  source                    = "./load-balancer"
  primary_subnet_ids        = module.networking.primary_subnet_ids
  dr_subnet_ids             = module.networking.dr_subnet_ids
  primary_security_group_id = module.security.primary_security_group_id
  dr_security_group_id      = module.security.dr_security_group_id

  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
  }
}

module "database" {
  source             = "./database"
  primary_subnet_ids = module.networking.primary_subnet_ids
  dr_subnet_ids      = module.networking.dr_subnet_ids

  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
  }
}

module "replication" {
  source = "./replication"

  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
  }
}

module "monitoring" {
  source = "./monitoring"
  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
  }

  primary_instance_id = module.compute.primary_instance_id
  dr_instance_id      = module.compute.dr_instance_id
}


module "dr_failover" {
  source = "./dr-failover"

  providers = {
    aws.primary = aws.primary
    aws.dr      = aws.dr
  }

  hosted_zone_id       = var.hosted_zone_id
  record_name          = "app.sachinawslearner.site"
  primary_alb_dns_name = module.load_balancer.primary_alb_dns_name
  dr_alb_dns_name      = module.load_balancer.dr_alb_dns_name
}