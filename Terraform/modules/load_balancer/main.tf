# Security Group for Application load balancer
resource "aws_security_group" "load_balancer_sg" {
  name        = "${var.project}_load_balancer_sg"
  description = "Security group for application load balancer"
    vpc_id      = aws_vpc.votingApp_vpc.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    tags = {
        Name = "${var.project}_load_balancer_sg"
    }
}


# Create S3 bucket for load balancer access logs
resource "aws_s3_bucket" "load_balancer_logs" {
  bucket = "votingapp-load_balancer-logs-tf-${random_id.bucket_id.hex}"
}

# Create target group
resource "aws_lb_target_group" "votingApp_tg" {
  name     = "votingApp_tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.aws_vpc.votingApp_vpc.id
}

resource "aws_lb" "votingApp_lb" {
  name               = "votingApp-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_sg.id]
  subnets            = module.vpc.aws_subnet.public_subnet

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.load_balancer_logs.id
    prefix  = "votingApp-load_balancer_logs"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "app_server_listener" {
  load_balancer_arn = aws_lb.app_server_listener.arn
  port              = "443"
  protocol          = "HTTPS"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.votingApp_tg.arn
  }
}