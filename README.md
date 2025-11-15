# AWS Infrastructure as Code

Automação completa de infraestrutura AWS usando Terraform, Docker, Ansible e GitHub Actions.

## 🏗️ Recursos

- **VPC** - Virtual Private Cloud com subnets públicas e privadas
- **EC2 + Auto Scaling** - Instâncias escaláveis automaticamente
- **RDS** - Banco de dados PostgreSQL com backups automáticos
- **CloudFront + S3** - CDN e armazenamento de assets estáticos
- **IAM + Security Groups** - Controle de acesso e segurança
- **CloudWatch** - Monitoramento e logging completo
- **Microservices** - Arquitetura de backend e frontend
- **CI/CD** - Pipeline automatizado com GitHub Actions

## 📋 Pré-requisitos

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configurado
- [Docker](https://www.docker.com/get-started) >= 20.10
- [Docker Compose](https://docs.docker.com/compose/install/) >= 2.0
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) >= 2.10
- Conta AWS com permissões adequadas

## 🚀 Quick Start

### 1. Configurar Credenciais AWS

```bash
aws configure
```

### 2. Clonar o Repositório

```bash
git clone https://github.com/your-org/aws-infrastructure-as-code.git
cd aws-infrastructure-as-code
```

### 3. Configurar Variáveis

```bash
# Para ambiente de desenvolvimento
cd terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars
vim terraform.tfvars  # Edite com seus valores

# Para ambiente de produção
cd terraform/environments/prod
cp terraform.tfvars.example terraform.tfvars
vim terraform.tfvars  # Edite com seus valores
```

### 4. Deploy da Infraestrutura

```bash
# Inicializar Terraform
terraform init

# Planejar mudanças
terraform plan

# Aplicar infraestrutura
terraform apply
```

### 5. Configurar Instâncias com Ansible

```bash
cd ansible

# Atualizar inventory com IPs das instâncias EC2
vim inventory.ini

# Executar playbook
ansible-playbook -i inventory.ini playbook.yml
```

### 6. Executar Aplicação Localmente (Docker Compose)

```bash
# Copiar arquivo de ambiente
cp .env.example .env
vim .env  # Configurar variáveis

# Iniciar serviços
docker-compose up -d

# Verificar logs
docker-compose logs -f

# Acessar aplicação
# Frontend: http://localhost:3000
# Backend: http://localhost:8080
# Grafana: http://localhost:3001
```

## 📁 Estrutura do Projeto

```
.
├── terraform/
│   ├── modules/
│   │   ├── vpc/              # Módulo VPC
│   │   ├── security/         # Security Groups e IAM
│   │   ├── compute/          # EC2 e Auto Scaling
│   │   ├── database/         # RDS
│   │   ├── storage/          # S3 e CloudFront
│   │   └── monitoring/       # CloudWatch
│   └── environments/
│       ├── dev/              # Ambiente de desenvolvimento
│       └── prod/             # Ambiente de produção
├── ansible/
│   ├── roles/
│   │   ├── common/           # Configurações comuns
│   │   ├── docker/           # Instalação do Docker
│   │   ├── monitoring/       # CloudWatch Agent
│   │   └── application/      # Deploy da aplicação
│   ├── playbook.yml          # Playbook principal
│   └── inventory.ini         # Inventário de hosts
├── microservices/
│   ├── backend/              # API Backend
│   └── frontend/             # Aplicação Frontend
├── docker/
│   ├── nginx/                # Configuração NGINX
│   ├── prometheus/           # Configuração Prometheus
│   └── grafana/              # Dashboards Grafana
├── .github/
│   └── workflows/            # GitHub Actions
└── docker-compose.yml        # Orquestração local
```

## 🔧 Módulos Terraform

### VPC Module
Cria a infraestrutura de rede:
- VPC com CIDR configurável
- Subnets públicas e privadas em múltiplas AZs
- Internet Gateway e NAT Gateways
- Route Tables
- VPC Flow Logs

### Security Module
Gerencia segurança:
- Security Groups para ALB, EC2 e RDS
- IAM Roles e Policies
- Instance Profiles

### Compute Module
Gerencia recursos de computação:
- Application Load Balancer
- Launch Template
- Auto Scaling Group
- CloudWatch Alarms para auto-scaling

### Database Module
Gerencia banco de dados:
- RDS PostgreSQL/MySQL
- Multi-AZ deployment (produção)
- Backups automáticos
- Read Replicas (opcional)
- Secrets Manager para credenciais

### Storage Module
Gerencia armazenamento:
- S3 Buckets (assets e logs)
- CloudFront Distribution
- Origin Access Identity
- Lifecycle rules

### Monitoring Module
Gerencia monitoramento:
- CloudWatch Dashboards
- CloudWatch Alarms
- SNS Topics para notificações
- Log Groups
- Metric Filters

## 🐳 Docker Compose

O arquivo `docker-compose.yml` inclui:

- **Backend** - API Node.js
- **Frontend** - React App
- **PostgreSQL** - Banco de dados
- **Redis** - Cache
- **NGINX** - Reverse proxy
- **Prometheus** - Métricas
- **Grafana** - Visualização

### Comandos Úteis

```bash
# Iniciar todos os serviços
docker-compose up -d

# Ver logs
docker-compose logs -f [service_name]

# Parar serviços
docker-compose down

# Rebuild serviços
docker-compose up -d --build

# Ver status
docker-compose ps
```

## 🤖 Ansible Playbooks

### Roles Disponíveis

1. **common** - Configurações básicas do sistema
2. **docker** - Instalação e configuração do Docker
3. **monitoring** - CloudWatch Agent e Node Exporter
4. **application** - Deploy da aplicação

### Executar Playbooks

```bash
# Executar playbook completo
ansible-playbook -i inventory.ini playbook.yml

# Executar role específica
ansible-playbook -i inventory.ini playbook.yml --tags common

# Dry run
ansible-playbook -i inventory.ini playbook.yml --check
```

## 🔄 CI/CD com GitHub Actions

### Workflows Disponíveis

#### Terraform Plan
- Executa em Pull Requests
- Valida código Terraform
- Mostra plano de mudanças
- Executa scans de segurança (Checkov, tfsec)

#### Terraform Apply
- Executa em push para main/develop
- Aplica mudanças na infraestrutura
- Suporta execução manual com workflow_dispatch

### Configurar Secrets

No GitHub, configure os seguintes secrets:

```
AWS_ROLE_TO_ASSUME - ARN do role IAM para GitHub Actions
SLACK_WEBHOOK_URL - URL do webhook Slack (opcional)
```

## 🔐 Segurança

### Boas Práticas Implementadas

- ✅ Encryption at rest (EBS, RDS, S3)
- ✅ Encryption in transit (HTTPS, TLS)
- ✅ Security Groups com princípio de menor privilégio
- ✅ IAM Roles com políticas específicas
- ✅ Secrets Manager para credenciais
- ✅ VPC Flow Logs habilitados
- ✅ CloudWatch Logs para auditoria
- ✅ Backups automáticos
- ✅ Multi-AZ deployment (produção)

## 📊 Monitoramento

### CloudWatch Dashboards

Acesse o dashboard após deploy:
```bash
terraform output cloudwatch_dashboard_name
```

### Métricas Monitoradas

- CPU Utilization
- Memory Usage
- Disk Usage
- Network I/O
- Application Errors
- Response Time
- Request Count
- Database Connections

## 💰 Custos

### Estimativa de Custos Mensais

**Ambiente Dev** (~$100-150/mês):
- EC2 t3.micro (1-2 instâncias)
- RDS db.t3.micro (Single-AZ)
- S3 + CloudFront (mínimo)

**Ambiente Prod** (~$500-800/mês):
- EC2 t3.small (2-6 instâncias)
- RDS db.t3.small (Multi-AZ)
- S3 + CloudFront
- NAT Gateway
- Backups e logs

## 📝 License

Este projeto está sob a licença MIT.

---

**Importante**: Lembre-se de revisar e ajustar as configurações de segurança, custos e compliance de acordo com as necessidades específicas da sua organização antes de usar em produção.