variable "project" {
  description = "The project name"
  type        = string
  default     = "votingApp"
}

variable "ami_id" {
  description = "The ami id used for the ec2"
  type        = string
  default     = "ami-07ff62358b87c7116"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "vpc_id" {
  type = string
}

variable "load_balancer_sg_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "aws_lb_target_group_arn" {
  type = string
}

variable "private_subnet" {
  type = string
}

variable "db_secrets_arn" {
  type = string
}