provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "devops_sg" {
  name        = "devops-project-sg"
  description = "Permitir trafego essencial para o projeto"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "devops_server" {
  ami                    = "ami-0fc5d935ebf8bc3bc" # Ubuntu Server 22.04 LTS
  instance_type          = "t2.micro"             # Usa exatamente o limite permitido
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  tags = {
    Name = "devops-all-in-one"
  }
}
