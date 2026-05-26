output "server_public_ip" {
  value       = aws_instance.devops_server.public_ip
  description = "IP Publico do Servidor Unificado"
}
