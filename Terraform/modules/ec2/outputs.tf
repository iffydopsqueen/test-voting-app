output "logic_server_instance" {
  value = aws_instance.logic_server_instance.id
}

output "application_server" {
  description = "public ip address of the application servers"
    value = aws_instance.app_server[*].public_ip
}

