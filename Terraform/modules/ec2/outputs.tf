output "logic_server_instance" {
  value = aws_instance.logic_server_instance.id
}

output "asg_arn" {
  value = aws_autoscaling_group.votingApp_asg.arn
}

output "app_server_security_group_id" {
  value = aws_security_group.app_server_sg.id
}

output "logic_server_sg_id" {
  value = aws_security_group.logic_server_sg.id
}

