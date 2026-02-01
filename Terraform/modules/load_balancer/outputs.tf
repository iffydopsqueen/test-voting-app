output "load_balancer_sg_id" {
  value = aws_security_group.load_balancer_sg.id
}

output "aws_lb_target_group_arn" {
  value = aws_lb_target_group.votingApp_tg.arn
}

output "aws_lb_target_group_id" {
  value = aws_lb_target_group.votingApp_tg.id
}


output "votingApp_lb_arn" {
  value = aws_lb.votingApp_lb.arn
}

output "app_server_listener" {
  value = aws_lb_listener.app_server_listener.id
}

output "s3_bucket_id" {
  value = aws_s3_bucket.load_balancer_logs.id
}