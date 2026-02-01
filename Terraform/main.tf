resource "random_password" "password" {
  length           = 20
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  min_upper        = 2
}

module "vpc" {
  source = "./modules/vpc"
}

module "secret_manager" {
  source      = "./modules/secret_manager"
  db_password = random_password.password.result
  db_username = var.db_username
}

module "load_balancer" {
  source         = "./modules/load_balancer"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
}

module "ec2" {
  source                  = "./modules/ec2"
  vpc_id                  = module.vpc.vpc_id
  load_balancer_sg_id     = module.load_balancer.load_balancer_sg_id
  public_subnets          = module.vpc.public_subnets
  aws_lb_target_group_arn = module.load_balancer.aws_lb_target_group_arn
  private_subnet          = module.vpc.private_subnet
  db_secrets_arn          = module.secret_manager.db_secrets_arn
}

module "rds" {
  source               = "./modules/rds"
  vpc_id               = module.vpc.vpc_id
  db_secrets_arn       = module.secret_manager.db_secrets_arn
  logic_server_sg_id   = module.ec2.logic_server_sg_id
  private_subnet       = module.vpc.private_subnet
  db_password = random_password.password.result
  db_username = var.db_username
}