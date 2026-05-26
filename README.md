# Automação de Infraestrutura e Observabilidade Unificada (AWS / Terraform / Ansible / Docker)

Este projeto demonstra a criação de uma infraestrutura robusta, automatizada e monitorada do zero na AWS. Utilizando conceitos modernos de Infraestrutura como Código (IaC), Gerenciamento de Configuração e SRE / Observabilidade, o ambiente provisiona um servidor unificado que roda uma aplicação web e uma stack completa de monitoramento encapsulada em containers.

---

## Arquitetura do Projeto

O projeto foi desenhado para seguir o padrão de arquitetura unificada em uma única instância EC2 (ambiente de laboratório/staging), isolando os serviços através de redes do Docker e garantindo a segurança por meio de regras estritas de firewall.

* Provedor de Nuvem: AWS (EC2, VPC, Security Group, Key Pairs)
* Provisionamento: Terraform
* Gerenciamento de Configuração & Deploy: Ansible (Organizado por Roles)
* Runtime das Aplicações: Docker & Docker Compose
* Serviços de Aplicação: Nginx (Servidor Web) + Node Exporter (Coletor de Métricas do Host)
* Serviços de Observabilidade: Prometheus (Base de Dados Temporal) + Grafana (Painéis Visuais)

---

## Tecnologias Utilizadas

* Terraform (v1.x)
* Ansible (v2.x)
* Docker & Docker Compose
* Prometheus
* Grafana
* UFW (Uncomplicated Firewall para segurança do Host)

---

## Estrutura de Pastas

```text
projeto-infra-completa/
├── terraform/               # Arquivos de provisionamento IaC
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── ansible/                 # Playbooks e automação de configuração
│   ├── inventory.ini        # Inventário dinâmico com o IP do host
│   ├── site.yml             # Playbook principal (Orquestrador)
│   └── roles/               # Camadas de configuração isoladas
│       ├── common/          # Configuração de OS, pacotes essenciais e UFW
│       ├── docker/          # Instalação do runtime do Docker e Compose
│       ├── app_deploy/      # Deploy da App (Nginx) e do Node Exporter
│       └── monitoring/      # Configuração e inicialização do Prometheus + Grafana
└── .gitignore               # Proteção de chaves (.pem) e estados (.tfstate)
Como Executar o Projeto
1. Provisionando a Infraestrutura (Terraform)
Navegue até a pasta do Terraform, inicialize o provedor e aplique o plano:

Bash
cd terraform
terraform init
terraform apply -auto-approve
Isso gerará a máquina na AWS e extrairá o IP público automaticamente no terminal.

2. Configurando e Implantando a Stack (Ansible)
Atualize o arquivo inventory.ini com o IP gerado pela AWS e rode o playbook orquestrador:

Bash
cd ../ansible
ansible-playbook -i inventory.ini site.yml
O Ansible aplicará o conceito de idempotência, configurando o sistema operacional, injetando as regras de firewall de forma cirúrgica e levantando as stacks do Docker de maneira isolada.

Desafios Técnicos Solucionados (Cultura SRE)
Durante o desenvolvimento do laboratório, foi identificado e corrigido um comportamento clássico de isolamento de redes de containers (Network Sandboxing):

O Problema: O container do Prometheus tentava coletar as métricas do Node Exporter utilizando o endereço de loopback (127.0.0.1:9100), resultando em Connection Refused devido ao isolamento de rede natural do Docker.

A Solução: Foi efetuado o troubleshooting via SSH direto no Host da AWS. A configuração do Prometheus foi corrigida para apontar diretamente para a interface de rede física da AWS (eth0), utilizando o IP privado do host (172.31.21.37), estabelecendo com sucesso o mapeamento ponta a ponta dos alvos (Targets).

Resultados da Observabilidade
Após a execução, os seguintes serviços ficam disponíveis para validação através do IP Público da instância:

Aplicação Web (Nginx): http://<IP_PUBLICO>:80

Central do Prometheus: http://<IP_PUBLICO>:9090/targets (Exibindo os coletores em status UP)

Cockpit Grafana: http://<IP_PUBLICO>:3000 (Painel integrado utilizando o ID 1860 - Node Exporter Full para métricas de CPU, Memória RAM e I/O de disco em tempo real).

Destruição e Controle de Custos
Para evitar custos desnecessários na plataforma AWS após os testes, a destruição de todo o ecossistema é feita de forma declarativa e limpa:

Bash
cd terraform
terraform destroy -auto-approve
