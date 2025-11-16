terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }

  # Backend configuration for state management
  backend "s3" {
    # Uncomment and configure for remote state
    # bucket         = "your-terraform-state-bucket"
    # key            = "prod/terraform.tfstate"
    # region         = "us-east-1"
    # encrypt        = true
    # dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# Provider for CloudFront certificates (must be in us-east-1)
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# VPC Module
module "vpc" {
  source = "../../modules/vpc"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = slice(data.aws_availability_zones.available.names, 0, 2)
  enable_nat_gateway   = var.enable_nat_gateway
  enable_flow_logs     = var.enable_flow_logs

  tags = var.tags
}

# Security Module
module "security" {
  source = "../../modules/security"

  project_name            = var.project_name
  vpc_id                  = module.vpc.vpc_id
  ssh_allowed_cidr_blocks = var.ssh_allowed_cidr_blocks

  tags = var.tags
}

# Compute Module
module "compute" {
  source = "../../modules/compute"

  project_name            = var.project_name
  environment             = var.environment
  vpc_id                  = module.vpc.vpc_id
  public_subnet_ids       = module.vpc.public_subnet_ids
  private_subnet_ids      = module.vpc.private_subnet_ids
  alb_security_group_id   = module.security.alb_security_group_id
  web_security_group_id   = module.security.web_security_group_id
  instance_profile_name   = module.security.ec2_instance_profile_name
  ami_id                  = data.aws_ami.amazon_linux_2.id
  instance_type           = var.instance_type
  key_name                = var.key_name
  min_size                = var.asg_min_size
  max_size                = var.asg_max_size
  desired_capacity        = var.asg_desired_capacity
  app_port                = var.app_port
  health_check_path       = var.health_check_path
  certificate_arn         = var.certificate_arn
  enable_deletion_protection = var.enable_alb_deletion_protection

  tags = var.tags
}

# Database Module
module "database" {
  source = "../../modules/database"

  project_name               = var.project_name
  private_subnet_ids         = module.vpc.private_subnet_ids
  database_security_group_id = module.security.database_security_group_id
  engine                     = var.db_engine
  engine_version             = var.db_engine_version
  instance_class             = var.db_instance_class
  allocated_storage          = var.db_allocated_storage
  max_allocated_storage      = var.db_max_allocated_storage
  db_name                    = var.db_name
  db_username                = var.db_username
  multi_az                   = var.db_multi_az
  backup_retention_period    = var.db_backup_retention_period
  deletion_protection        = var.db_deletion_protection
  enable_performance_insights = var.db_enable_performance_insights
  parameter_group_family     = var.db_parameter_group_family
  create_read_replica        = var.db_create_read_replica

  tags = var.tags
}

# Storage Module
module "storage" {
  source = "../../modules/storage"

  project_name          = var.project_name
  environment           = var.environment
  enable_versioning     = var.s3_enable_versioning
  enable_lifecycle_rules = var.s3_enable_lifecycle_rules
  default_root_object   = var.cloudfront_default_root_object
  price_class           = var.cloudfront_price_class
  domain_aliases        = var.cloudfront_domain_aliases
  acm_certificate_arn   = var.cloudfront_acm_certificate_arn

  tags = var.tags
}

# Monitoring Module
module "monitoring" {
  source = "../../modules/monitoring"

  project_name           = var.project_name
  aws_region             = var.aws_region
  alarm_email_endpoints  = var.alarm_email_endpoints
  log_retention_days     = var.log_retention_days
  target_group_arn       = module.compute.target_group_arn
  alb_arn                = module.compute.alb_arn

  tags = var.tags
}

# VPC Endpoints Module
module "vpc_endpoints" {
  source = "../../modules/vpc-endpoints"

  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = var.vpc_cidr
  private_subnet_ids = module.vpc.private_subnet_ids
  route_table_ids    = concat([module.vpc.public_route_table_id], module.vpc.private_route_table_ids)

  enable_s3_endpoint              = var.enable_s3_endpoint
  enable_dynamodb_endpoint        = var.enable_dynamodb_endpoint
  enable_ssm_endpoints            = var.enable_ssm_endpoints
  enable_logs_endpoint            = var.enable_logs_endpoint
  enable_monitoring_endpoint      = var.enable_monitoring_endpoint
  enable_secretsmanager_endpoint  = var.enable_secretsmanager_endpoint
  enable_kms_endpoint             = var.enable_kms_endpoint

  tags = var.tags
}

# Session Manager/Bastion Module
module "bastion" {
  source = "../../modules/bastion"

  project_name             = var.project_name
  vpc_id                   = module.vpc.vpc_id
  ec2_iam_role_name        = module.security.ec2_iam_role_arn != "" ? split("/", module.security.ec2_iam_role_arn)[1] : ""
  enable_session_logging   = var.enable_session_logging
  enable_cloudwatch_logging = var.enable_cloudwatch_logging
  enable_kms_encryption    = var.enable_kms_encryption
  alarm_actions            = [module.monitoring.sns_topic_arn]

  tags = var.tags

  depends_on = [module.vpc_endpoints]
}

# CloudTrail Module
module "cloudtrail" {
  source = "../../modules/cloudtrail"

  project_name                  = var.project_name
  is_multi_region_trail         = var.cloudtrail_multi_region
  enable_kms_encryption         = var.cloudtrail_enable_kms
  enable_cloudwatch_logs        = var.cloudtrail_enable_cloudwatch
  enable_data_events            = var.cloudtrail_enable_data_events
  enable_insights               = var.cloudtrail_enable_insights
  enable_security_alarms        = var.cloudtrail_enable_security_alarms
  alarm_actions                 = [module.monitoring.sns_topic_arn]

  tags = var.tags
}

# WAF Module
module "waf" {
  source = "../../modules/waf"

  project_name             = var.project_name
  scope                    = "REGIONAL"
  alb_arn                  = module.compute.alb_arn
  rate_limit               = var.waf_rate_limit
  enable_ip_reputation     = var.waf_enable_ip_reputation
  enable_bot_control       = var.waf_enable_bot_control
  enable_geo_blocking      = var.waf_enable_geo_blocking
  blocked_countries        = var.waf_blocked_countries
  alarm_actions            = [module.monitoring.sns_topic_arn]

  tags = var.tags
}

# Route 53 Module
module "route53" {
  count  = var.create_route53_zone ? 1 : 0
  source = "../../modules/route53"

  providers = {
    aws.us-east-1 = aws.us-east-1
  }

  project_name                   = var.project_name
  domain_name                    = var.domain_name
  create_hosted_zone             = var.create_route53_zone
  create_certificate             = var.create_route53_certificate
  create_cloudfront_certificate  = var.create_cloudfront_certificate
  subject_alternative_names      = var.certificate_sans
  alb_dns_name                   = module.compute.alb_dns_name
  alb_zone_id                    = module.compute.alb_zone_id
  cloudfront_domain_name         = module.storage.cloudfront_domain_name
  cloudfront_zone_id             = module.storage.cloudfront_hosted_zone_id
  enable_health_checks           = var.route53_enable_health_checks
  alarm_actions                  = [module.monitoring.sns_topic_arn]

  tags = var.tags
}
