output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet
}

output "private_subnet_id" {
  value = module.vpc.private_subnets[*]
}

output "db_instance_endpoint" {
  value = module.rds.db_instance_endpoint
}

output "db_name" {
  value = module.rds.db_name
}

output "db_username" {
  value = module.rds.db_username
}

output "db_port" {
  value = module.rds.db_port
}