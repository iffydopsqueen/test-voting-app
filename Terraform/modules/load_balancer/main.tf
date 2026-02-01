# Security Group for Application load balancer
resource "aws_security_group" "load_balancer_sg" {
  name        = "${var.project}_load_balancer_sg"
  description = "Security group for application load balancer"
  vpc_id      = var.vpc_id

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
  bucket = "votingapp-load-balancer-logs-tf-thecloudchief-123456789"
}

resource "aws_s3_bucket_policy" "allow_elb_logging" {
  bucket = aws_s3_bucket.load_balancer_logs.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AWSLogDeliveryWrite"
        Effect    = "Allow"
        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        }
        Action = [
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.load_balancer_logs.arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },
      {
        Sid       = "AWSLogDeliveryAclCheck"
        Effect    = "Allow"
        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        }
        Action = [
          "s3:GetBucketAcl"
        ]
        Resource = aws_s3_bucket.load_balancer_logs.arn
      }
    ]
  })
}


resource "aws_lb" "votingApp_lb" {
  name               = "votingApp-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_sg.id]
  subnets            = var.public_subnets
  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.load_balancer_logs.bucket
    prefix  = "votingApp-load_balancer_logs"
    enabled = true
  }
}

# Create target group
resource "aws_lb_target_group" "votingApp_tg" {
  name     = "votingApp-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "app_server_listener" {
  load_balancer_arn = aws_lb.votingApp_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = null
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.votingApp_tg.arn
  }
}