variable "aws_region" {
  default     = "us-east-1"
  description = "Regiao da AWS onde a infraestrutura sera provisionada"
}

variable "ssh_key_name" {
  default     = "ansible-key"
  description = "Nome da chave privada SSH cadastrada na AWS"
}
