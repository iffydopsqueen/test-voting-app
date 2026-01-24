output "load_balancer_sg" {
  value = aws_security_group.load_balancer_sg.id
}

output "aws_lb_target_group" {
  value = aws_lb_target_group.votingApp_tg.id
}

output "aws_lb_target_group_arn" {
  value = aws_lb_target_group.votingApp_tg.arn
}

output "votingApp_lb" {
  value = aws_lb.votingApp_lb.id
}

output "app_server_listener" {
  value = aws_lb_listener.app_server_listener.id
}