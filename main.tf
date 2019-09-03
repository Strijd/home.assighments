module "vpc" {
  source            = "/home/anan/transmit/vpc"
  environment       = var.Environment
  aws_access_key    = var.aws_access_key
  aws_secret_key    = var.aws_secret_key
  aws_public_zones  = var.aws_public_zones
  aws_private_zones = var.aws_private_zones
  aws_region        = var.aws_region
  vpc_cidr          = var.network_cidr
  numberofbits      = var.numberofbits
  env_name          = var.environment_name
}

module "ec2" {
  source            = "/home/anan/transmit/ec2"
  ec2_group         = var.ec2_instance
  vpc_public_subnet_id      = module.vpc.az_public_id
  vpc_private_subnet_id     = module.vpc.az_private_id
  vpc_security_group_ids = [module.vpc.public_security_groups]
  associate_public_ip_address = true
  env_name          = var.environment_name
}
