# Security Group for Database server
resource "aws_security_group" "db_server_sg" {
  name        = "${var.project}_db_server_sg"
  description = "Security group for database server"
    vpc_id      = var.vpc_id
    ingress {
        description = "Allow MySQL from Logic server"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        security_groups = [var.logic_server_sg_id]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    tags = {
        Name = "${var.project}_db_server_sg"
    }
}


resource "aws_db_instance" "votingApp_db_server" {
  allocated_storage    = 10
  db_name              = var.db_name
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  parameter_group_name = var.db_parameter_group_name
  username = var.db_username
  password = var.db_password
  skip_final_snapshot  = true
  availability_zone = var.availability_zone[0]
  vpc_security_group_ids = [aws_security_group.db_server_sg.id]
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  

  tags = {
    Name = "${var.project}_db_server"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "rds-db-subnet-group"
  subnet_ids = [var.private_subnet]

  tags = {
    Name = "rds-db-subnet-group"
  }
  
}

