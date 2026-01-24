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

  target_group_arns = module.load_balancer.aws_lb_target_group_arn

  tag {
    key = "Name"
    value = "voting_asg_instance"
    propagate_at_launch = true
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_db_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "ec2_role_policy" {
  name = "ec2_role_policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
        ]
        Effect   = "Allow"
        Resource = module.secret_manager.db_secrets_arn
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "logic_server_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = element(module.vpc.private_subnet, 0)
  vpc_security_group_ids = [aws_security_group.logic_server_sg.id]
  public_ip    = false
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  tags = {
    Name = "${var.project}_logic_server_instance"
  }
  
}



