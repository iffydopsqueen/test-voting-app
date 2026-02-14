output "votingApp_db_server_arn" {
  value = aws_db_instance.votingApp_db_server.arn
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.db_subnet_group.name
}

output "db_instance_endpoint" {
  value = aws_db_instance.votingApp_db_server.endpoint
}

output "db_name" {
  value = aws_db_instance.votingApp_db_server.db_name
}

output "db_username" {
  value = aws_db_instance.votingApp_db_server.username
}

output "db_port" {
  value = aws_db_instance.votingApp_db_server.port
}