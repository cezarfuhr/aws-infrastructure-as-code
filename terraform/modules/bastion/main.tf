# Bastion/Session Manager Module - Secure Access

# Note: This module enhances the existing IAM role for EC2 with Session Manager permissions
# No bastion host needed - uses AWS Systems Manager Session Manager

# S3 Bucket for Session Manager logs
resource "aws_s3_bucket" "session_logs" {
  count  = var.enable_session_logging ? 1 : 0
  bucket = "${var.project_name}-session-manager-logs-${data.aws_caller_identity.current.account_id}"

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-session-logs"
    }
  )
}

# S3 Bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "session_logs" {
  count  = var.enable_session_logging ? 1 : 0
  bucket = aws_s3_bucket.session_logs[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 Bucket public access block
resource "aws_s3_bucket_public_access_block" "session_logs" {
  count  = var.enable_session_logging ? 1 : 0
  bucket = aws_s3_bucket.session_logs[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "session_logs" {
  count  = var.enable_session_logging ? 1 : 0
  bucket = aws_s3_bucket.session_logs[0].id

  rule {
    id     = "expire-old-logs"
    status = "Enabled"

    expiration {
      days = var.log_retention_days
    }
  }
}

# CloudWatch Log Group for Session Manager
resource "aws_cloudwatch_log_group" "session_logs" {
  count             = var.enable_cloudwatch_logging ? 1 : 0
  name              = "/aws/ssm/${var.project_name}"
  retention_in_days = var.cloudwatch_log_retention_days

  tags = var.tags
}

# KMS Key for Session Manager encryption
resource "aws_kms_key" "session_manager" {
  count                   = var.enable_kms_encryption ? 1 : 0
  description             = "KMS key for Session Manager encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow Session Manager to use the key"
        Effect = "Allow"
        Principal = {
          Service = "ssm.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-session-manager-kms"
    }
  )
}

# KMS Key Alias
resource "aws_kms_alias" "session_manager" {
  count         = var.enable_kms_encryption ? 1 : 0
  name          = "alias/${var.project_name}-session-manager"
  target_key_id = aws_kms_key.session_manager[0].key_id
}

# SSM Document for Session Manager preferences
resource "aws_ssm_document" "session_manager_prefs" {
  name            = "${var.project_name}-session-manager-prefs"
  document_type   = "Session"
  document_format = "JSON"

  content = jsonencode({
    schemaVersion = "1.0"
    description   = "Document to configure session preferences"
    sessionType   = "Standard_Stream"
    inputs = {
      s3BucketName                = var.enable_session_logging ? aws_s3_bucket.session_logs[0].id : ""
      s3KeyPrefix                 = "session-logs/"
      s3EncryptionEnabled         = true
      cloudWatchLogGroupName      = var.enable_cloudwatch_logging ? aws_cloudwatch_log_group.session_logs[0].name : ""
      cloudWatchEncryptionEnabled = var.enable_kms_encryption
      cloudWatchStreamingEnabled  = var.enable_cloudwatch_logging
      kmsKeyId                    = var.enable_kms_encryption ? aws_kms_key.session_manager[0].id : ""
      runAsEnabled                = var.run_as_enabled
      runAsDefaultUser            = var.run_as_default_user
      idleSessionTimeout          = var.idle_session_timeout
      maxSessionDuration          = var.max_session_duration
    }
  })

  tags = var.tags
}

# IAM Policy for Session Manager
resource "aws_iam_policy" "session_manager" {
  name        = "${var.project_name}-session-manager-policy"
  description = "Policy for Session Manager access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Resource = var.enable_session_logging ? "${aws_s3_bucket.session_logs[0].arn}/*" : "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetEncryptionConfiguration"
        ]
        Resource = var.enable_session_logging ? aws_s3_bucket.session_logs[0].arn : "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = var.enable_cloudwatch_logging ? "${aws_cloudwatch_log_group.session_logs[0].arn}:*" : "*"
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = var.enable_kms_encryption ? aws_kms_key.session_manager[0].arn : "*"
      }
    ]
  })

  tags = var.tags
}

# Attach Session Manager policy to EC2 role
resource "aws_iam_role_policy_attachment" "session_manager" {
  count      = var.ec2_iam_role_name != "" ? 1 : 0
  role       = var.ec2_iam_role_name
  policy_arn = aws_iam_policy.session_manager.arn
}

# Optional: Create a dedicated bastion security group
resource "aws_security_group" "bastion" {
  count       = var.create_bastion_security_group ? 1 : 0
  name_prefix = "${var.project_name}-bastion-"
  description = "Security group for bastion access (Session Manager)"
  vpc_id      = var.vpc_id

  # No inbound rules needed - Session Manager uses outbound only
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-bastion-sg"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# CloudWatch Metric Filter for Session Manager activity
resource "aws_cloudwatch_log_metric_filter" "session_started" {
  count          = var.enable_cloudwatch_logging ? 1 : 0
  name           = "${var.project_name}-session-started"
  log_group_name = aws_cloudwatch_log_group.session_logs[0].name
  pattern        = "[...] SessionStarted"

  metric_transformation {
    name      = "SessionStarted"
    namespace = var.project_name
    value     = "1"
    default_value = "0"
  }
}

# CloudWatch Alarm for unusual session activity
resource "aws_cloudwatch_metric_alarm" "unusual_session_activity" {
  count               = var.enable_cloudwatch_logging && var.enable_activity_alarms ? 1 : 0
  alarm_name          = "${var.project_name}-unusual-session-activity"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "SessionStarted"
  namespace           = var.project_name
  period              = "300"
  statistic           = "Sum"
  threshold           = var.session_activity_threshold
  alarm_description   = "Unusual number of Session Manager sessions started"
  alarm_actions       = var.alarm_actions

  tags = var.tags
}

# Data sources
data "aws_caller_identity" "current" {}
