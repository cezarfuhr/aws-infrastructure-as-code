# AWS Infrastructure as Code

Automação completa de infraestrutura AWS usando Terraform, Docker, Ansible e GitHub Actions.

## 🏗️ Recursos

### Infraestrutura Core
- **VPC** - Virtual Private Cloud com subnets públicas e privadas
- **EC2 + Auto Scaling** - Instâncias escaláveis automaticamente
- **RDS** - Banco de dados PostgreSQL com backups automáticos
- **CloudFront + S3** - CDN e armazenamento de assets estáticos

### Segurança e Compliance
- **WAF** - Web Application Firewall com proteção contra SQL injection, XSS e DDoS
- **CloudTrail** - Auditoria completa de ações AWS
- **IAM + Security Groups** - Controle de acesso e segurança com least privilege
- **Session Manager** - Acesso seguro sem bastion host ou chaves SSH
- **Secrets Manager** - Gerenciamento seguro de credenciais

### Rede e Performance
- **VPC Endpoints** - Redução de custos eliminando NAT Gateway para serviços AWS
- **Route 53** - DNS gerenciado com health checks e failover
- **CloudFront** - CDN global para melhor performance

### Observabilidade
- **CloudWatch** - Monitoramento e logging completo
- **Dashboards** - Visualização de métricas em tempo real
- **Alarmes** - Notificações automáticas de problemas

### DevOps
- **Microservices** - Arquitetura de backend e frontend
- **Docker Compose** - Orquestração local
- **Ansible** - Automação de configuração
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

### WAF Module
Web Application Firewall:
- Proteção contra SQL Injection
- Proteção contra XSS
- Rate limiting (DDoS protection)
- IP reputation lists
- Geographic blocking (opcional)
- Bot control (opcional)

### CloudTrail Module
Auditoria e compliance:
- Trail multi-region
- Encriptação KMS
- Integração com CloudWatch Logs
- S3 bucket com lifecycle
- Alarmes de segurança
- Data events (opcional)

### Session Manager/Bastion Module
Acesso seguro sem SSH:
- AWS Systems Manager Session Manager
- Sem necessidade de bastion host
- Sem chaves SSH expostas
- Logging de todas as sessões
- Encriptação KMS
- Auditoria completa

### VPC Endpoints Module
Redução de custos:
- Gateway Endpoints (S3, DynamoDB) - Grátis
- Interface Endpoints para SSM (Session Manager)
- Interface Endpoints para CloudWatch
- Interface Endpoints para Secrets Manager
- Elimina necessidade de NAT Gateway
- Reduz custos de transfer

### Route 53 Module
DNS e certificados:
- Hosted zones
- DNS records (A, CNAME, MX, TXT)
- ACM certificates com validação DNS
- Health checks
- Failover automático
- Certificados CloudFront

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

**Ambiente Dev** (~$120-180/mês):
- EC2 t3.micro (1-2 instâncias): ~$15/mês
- RDS db.t3.micro (Single-AZ): ~$15/mês
- S3 + CloudFront (mínimo): ~$10/mês
- VPC Endpoints (SSM + Logs): ~$15/mês
- WAF: ~$15/mês
- CloudTrail: ~$5/mês
- Session Manager: ~$5/mês
- **Total**: ~$80-120/mês (sem NAT Gateway)

**Ambiente Prod** (~$400-600/mês):
- EC2 t3.small (2-6 instâncias): ~$60-180/mês
- RDS db.t3.small (Multi-AZ): ~$70/mês
- S3 + CloudFront: ~$50/mês
- VPC Endpoints: ~$30/mês
- WAF: ~$15/mês
- CloudTrail: ~$10/mês
- Route 53: ~$5/mês
- Backups e logs: ~$20/mês
- **Total**: ~$260-380/mês (economizando ~$100/mês do NAT Gateway)

### Economia com VPC Endpoints

Com VPC Endpoints, você elimina:
- **NAT Gateway**: $32/mês por AZ + $0.045/GB transfer = ~$50-150/mês economizados
- **Data Transfer**: Redução de 60-80% nos custos de transfer

**ROI**: Os VPC Endpoints se pagam eliminando apenas 1 NAT Gateway!

## 🔒 Recursos de Segurança Adicionais

### Acessar Instâncias com Session Manager

```bash
# Listar instâncias disponíveis
aws ec2 describe-instances --filters "Name=tag:Project,Values=aws-infra" --query 'Reservations[].Instances[].[InstanceId,Tags[?Key==`Name`].Value|[0],State.Name]' --output table

# Conectar via Session Manager
aws ssm start-session --target i-1234567890abcdef0

# Port forwarding para acessar RDS
aws ssm start-session --target i-1234567890abcdef0 \
    --document-name AWS-StartPortForwardingSession \
    --parameters '{"portNumber":["5432"],"localPortNumber":["5432"]}'
```

### Visualizar Logs do CloudTrail

```bash
# Ver eventos recentes
aws cloudtrail lookup-events --max-results 10

# Buscar eventos específicos
aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=RunInstances

# Ver logs no CloudWatch
aws logs tail /aws/cloudtrail/aws-infra --follow
```

### Gerenciar WAF

```bash
# Ver regras bloqueadas
aws wafv2 get-sampled-requests \
    --web-acl-arn <web-acl-arn> \
    --rule-metric-name BlockedRequests \
    --scope REGIONAL \
    --time-window StartTime=<timestamp>,EndTime=<timestamp>

# Adicionar IP à blacklist
aws wafv2 update-ip-set \
    --name aws-infra-ip-blacklist \
    --scope REGIONAL \
    --addresses "1.2.3.4/32"
```

### Gerenciar Route 53

```bash
# Listar hosted zones
aws route53 list-hosted-zones

# Criar novo record
aws route53 change-resource-record-sets \
    --hosted-zone-id <zone-id> \
    --change-batch file://record-changes.json

# Ver health check status
aws route53 get-health-check-status --health-check-id <id>
```

## 🛡️ Boas Práticas de Segurança

### Checklist de Segurança

- ✅ Habilitar MFA para todos os usuários IAM
- ✅ Usar VPC Endpoints para reduzir exposição à internet
- ✅ Habilitar CloudTrail em todas as regiões
- ✅ Configurar WAF com rate limiting
- ✅ Usar Session Manager ao invés de SSH direto
- ✅ Encriptar todos os dados em repouso (EBS, RDS, S3)
- ✅ Encriptar dados em trânsito (TLS/HTTPS)
- ✅ Rotacionar credenciais regularmente
- ✅ Revisar security groups mensalmente
- ✅ Habilitar GuardDuty para detecção de ameaças
- ✅ Configurar AWS Config para compliance
- ✅ Implementar least privilege em IAM policies

### Compliance

Esta infraestrutura atende requisitos de:
- **SOC 2**: CloudTrail, encryption, access logs
- **PCI DSS**: WAF, encryption, network segmentation
- **HIPAA**: Encryption at rest/transit, audit logs
- **GDPR**: Data encryption, audit trails, access controls

## 📝 License

Este projeto está sob a licença MIT.

---

**Importante**: Lembre-se de revisar e ajustar as configurações de segurança, custos e compliance de acordo com as necessidades específicas da sua organização antes de usar em produção.