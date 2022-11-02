module "iam" {
  source = "./iam"

  kms_key_arn                 = module.kms.kms_key_arn
  prefix_name                 = var.prefix_name
  secrets_manager_arn         = var.secrets_manager_arn
}

module "kms" {
  source = "./kms"

  common_tags               = var.common_tags
  kms_key_deletion_window   = var.kms_key_deletion_window
  prefix_name               = var.prefix_name
}

module "loadbalancer" {
  source = "./loadbalancer"

  allowed_inbound_cidrs   = var.allowed_inbound_cidrs_lb
  common_tags             = var.common_tags
  lb_certificate_arn      = var.lb_certificate_arn
  lb_deregistration_delay = var.lb_deregistration_delay
  lb_health_check_path    = var.lb_health_check_path
  prefix_name             = var.prefix_name
  ssl_policy              = var.ssl_policy
  vault_sg_id             = module.vm-instances.vault_sg_id
  vpc_id                  = module.vpc.vpc_id
  public-subnet-1         = module.vpc.public-subnet-1
  public-subnet-2         = module.vpc.public-subnet-2
  public-subnet-3         = module.vpc.public-subnet-3
  protocol                = var.protocol
}

module "vpc" {
  source = "./vpc_module"

  prefix_name = var.prefix_name
  env         = var.env
  cidr        = var.cidr
  common_tags = var.common_tags
}

locals {
  vault_target_group_arns = concat(
    [module.loadbalancer.vault_target_group_arn]
  )
}

module "vm-instances" {
  source = "./vm-instances"

  allowed_inbound_cidrs_ssh   = var.allowed_inbound_cidrs_ssh
  aws_iam_instance_profile    = module.iam.aws_iam_instance_profile
  common_tags                 = var.common_tags
  instance_type               = var.instance_type
  key_name                    = var.key_name
  node_count                  = var.node_count
  user_supplied_ami_id        = var.user_supplied_ami_id
  vault_lb_sg_id              = module.loadbalancer.vault_lb_sg_id
  vault_target_group_arns     = local.vault_target_group_arns
  vpc_id                      = module.vpc.vpc_id
  aws_region                  = var.aws_region
  kms_key_arn                 = module.kms.kms_key_arn
  leader_tls_servername       = var.leader_tls_servername
  prefix_name                 = var.prefix_name
  secrets_manager_arn         = var.secrets_manager_arn
  vault_version               = var.vault_version
  private-subnet-1            = module.vpc.private-subnet-1
  private-subnet-2            = module.vpc.private-subnet-2
  private-subnet-3            = module.vpc.private-subnet-3
}

module "route53" {
  source = "./route53"

  elb_dns_name = module.loadbalancer.vault_lb_dns_name
  elb_zone_id  = module.loadbalancer.vault_lb_zone_id
  route53_zone_id = var.route53_zone_id
  subdomain    = var.subdomain
}