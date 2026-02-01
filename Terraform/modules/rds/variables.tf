variable "project" {
  description = "The project name"
  type = string
  default = "votingApp"
}
variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  type = string
  default = "db.t2.micro"
}
variable "db_allocated_storage" {
  description = "The allocated storage in GBs for the RDS instance"
  type = number
  default = 10
}
variable "db_engine" {
  description = "The database engine for the RDS instance"
  type = string
  default = "mysql"
}
variable "db_engine_version" {
  description = "The database engine version for the RDS instance"
  type = string
  default = "8.0"
}
variable "db_name" {
  description = "The name of the database to create"
  type = string
  default = "mydb"
}

variable "db_parameter_group_name" { 
  description = "The parameter group name for the RDS instance"
  type = string
  default = "default.mysql8.0"
}

variable "availability_zone" {
  description = "list of availability zones to be deployed to"
  type = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "vpc_id" {
  type = string
}

variable "db_secrets_arn" {
  type = string
}

variable "logic_server_sg_id" {
  type = string
}


variable "private_subnet" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

