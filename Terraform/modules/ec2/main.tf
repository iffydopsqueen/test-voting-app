# Security Group for Application servers
resource "aws_security_group" "app_server_sg" {
  name        = "${var.project}_app_server_sg"
  description = "Security group for application servers"
    vpc_id      = aws_vpc.votingApp_vpc.id
    ingress {
        description = "Allow HTTP from Load Balancer"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        security_groups = [aws_security_group.load_balancer_sg.id]
    }

    ingress {
        description = "Allow HTTPS from Load Balancer"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        security_groups = [aws_security_group.load_balancer_sg.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    tags = {
        Name = "${var.project}_app_server_sg"
    }
}

# Security Group for Logic server
resource "aws_security_group" "logic_server_sg" {
  name        = "${var.project}_logic_server_sg"
  description = "Security group for logic server"
    vpc_id      = aws_vpc.votingApp_vpc.id
    ingress {
        description = "Allow HTTP from Application servers"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        security_groups = [aws_security_group.app_server_sg.id]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    tags = {
        Name = "${var.project}_logic_server_sg"
    }
}

# Security Group for Database server
resource "aws_security_group" "db_server_sg" {
  name        = "${var.project}_db_server_sg"
  description = "Security group for database server"
    vpc_id      = aws_vpc.votingApp_vpc.id
    ingress {
        description = "Allow MySQL from Logic server"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        security_groups = [aws_security_group.logic_server_sg.id]
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


resource "aws_launch_template" "votingApp_launch_template" {
  name_prefix = "votingApp-"
  image_id = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.app_server_sg]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      name = "asg_instance_template"
    }
  }
}

# Define placement group for the instances
resource "aws_placement_group" "instance_placement_group" {
  name     = "instance_placement_group"
  strategy = "spread"
}


resource "aws_autoscaling_group" "votingApp_asg" {
  name                      = "votingApp_asg"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  placement_group           = aws_placement_group.instance_placement_group.id
  vpc_zone_identifier       = module.vpc.public_subnet

  launch_template {
    id      = aws_launch_template.votingApp_launch_template.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.votingApp_tg.arn]

  tag {
    key = "Name"
    value = "voting_asg_instance"
    propagate_at_launch = true
  }
}





