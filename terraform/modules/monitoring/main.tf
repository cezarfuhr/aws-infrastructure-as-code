# Monitoring Module - CloudWatch Dashboards & Alarms

# SNS Topic for alarms
resource "aws_sns_topic" "alarms" {
  name = "${var.project_name}-alarms"

  tags = var.tags
}

# SNS Topic Subscription
resource "aws_sns_topic_subscription" "email" {
  count     = length(var.alarm_email_endpoints)
  topic_arn = aws_sns_topic.alarms.arn
  protocol  = "email"
  endpoint  = var.alarm_email_endpoints[count.index]
}

# CloudWatch Log Group for application logs
resource "aws_cloudwatch_log_group" "application" {
  name              = "/aws/${var.project_name}/application"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", { stat = "Average" }],
            ["AWS/ApplicationELB", "TargetResponseTime", { stat = "Average" }],
            ["AWS/RDS", "CPUUtilization", { stat = "Average" }],
            ["AWS/RDS", "DatabaseConnections", { stat = "Average" }]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "System Overview"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", { stat = "Sum" }],
            ["AWS/ApplicationELB", "HTTPCode_Target_2XX_Count", { stat = "Sum" }],
            ["AWS/ApplicationELB", "HTTPCode_Target_4XX_Count", { stat = "Sum" }],
            ["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", { stat = "Sum" }]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "Load Balancer Metrics"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/RDS", "FreeableMemory", { stat = "Average" }],
            ["AWS/RDS", "FreeStorageSpace", { stat = "Average" }],
            ["AWS/RDS", "ReadLatency", { stat = "Average" }],
            ["AWS/RDS", "WriteLatency", { stat = "Average" }]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Database Performance"
        }
      },
      {
        type = "log"
        properties = {
          query   = "SOURCE '${aws_cloudwatch_log_group.application.name}' | fields @timestamp, @message | sort @timestamp desc | limit 20"
          region  = var.aws_region
          title   = "Recent Application Logs"
        }
      }
    ]
  })
}

# CloudWatch Metric Filter for errors
resource "aws_cloudwatch_log_metric_filter" "error_count" {
  name           = "${var.project_name}-error-count"
  log_group_name = aws_cloudwatch_log_group.application.name
  pattern        = "[time, request_id, event_type = ERROR*, ...]"

  metric_transformation {
    name      = "ErrorCount"
    namespace = var.project_name
    value     = "1"
    default_value = "0"
  }
}

# CloudWatch Alarm for application errors
resource "aws_cloudwatch_metric_alarm" "application_errors" {
  alarm_name          = "${var.project_name}-application-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ErrorCount"
  namespace           = var.project_name
  period              = "300"
  statistic           = "Sum"
  threshold           = var.error_threshold
  alarm_description   = "This metric monitors application errors"
  alarm_actions       = [aws_sns_topic.alarms.arn]

  tags = var.tags
}

# CloudWatch Alarm for ALB unhealthy targets
resource "aws_cloudwatch_metric_alarm" "unhealthy_targets" {
  count               = var.target_group_arn != "" ? 1 : 0
  alarm_name          = "${var.project_name}-unhealthy-targets"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "0"
  alarm_description   = "This metric monitors unhealthy targets"
  alarm_actions       = [aws_sns_topic.alarms.arn]

  dimensions = {
    TargetGroup  = split(":", var.target_group_arn)[5]
    LoadBalancer = split("loadbalancer/", var.alb_arn)[1]
  }

  tags = var.tags
}

# CloudWatch Alarm for ALB 5xx errors
resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  count               = var.alb_arn != "" ? 1 : 0
  alarm_name          = "${var.project_name}-alb-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  statistic           = "Sum"
  threshold           = var.error_5xx_threshold
  alarm_description   = "This metric monitors ALB 5xx errors"
  alarm_actions       = [aws_sns_topic.alarms.arn]

  dimensions = {
    LoadBalancer = split("loadbalancer/", var.alb_arn)[1]
  }

  tags = var.tags
}

# CloudWatch Alarm for high response time
resource "aws_cloudwatch_metric_alarm" "high_response_time" {
  count               = var.target_group_arn != "" ? 1 : 0
  alarm_name          = "${var.project_name}-high-response-time"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  statistic           = "Average"
  threshold           = var.response_time_threshold
  alarm_description   = "This metric monitors target response time"
  alarm_actions       = [aws_sns_topic.alarms.arn]

  dimensions = {
    TargetGroup  = split(":", var.target_group_arn)[5]
    LoadBalancer = split("loadbalancer/", var.alb_arn)[1]
  }

  tags = var.tags
}

# CloudWatch Composite Alarm for overall health
resource "aws_cloudwatch_composite_alarm" "system_health" {
  alarm_name          = "${var.project_name}-system-health"
  alarm_description   = "Composite alarm for overall system health"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.alarms.arn]

  alarm_rule = join(" OR ", concat(
    [aws_cloudwatch_metric_alarm.application_errors.alarm_name],
    var.target_group_arn != "" ? [aws_cloudwatch_metric_alarm.unhealthy_targets[0].alarm_name] : [],
    var.alb_arn != "" ? [aws_cloudwatch_metric_alarm.alb_5xx_errors[0].alarm_name] : [],
    var.target_group_arn != "" ? [aws_cloudwatch_metric_alarm.high_response_time[0].alarm_name] : []
  ))

  tags = var.tags
}

# CloudWatch Insights Query for common patterns
resource "aws_cloudwatch_query_definition" "error_analysis" {
  name = "${var.project_name}/error-analysis"

  log_group_names = [
    aws_cloudwatch_log_group.application.name
  ]

  query_string = <<-QUERY
    fields @timestamp, @message
    | filter @message like /ERROR/
    | stats count() by bin(5m)
  QUERY
}

resource "aws_cloudwatch_query_definition" "slow_requests" {
  name = "${var.project_name}/slow-requests"

  log_group_names = [
    aws_cloudwatch_log_group.application.name
  ]

  query_string = <<-QUERY
    fields @timestamp, @message, duration
    | filter duration > ${var.slow_request_threshold}
    | sort duration desc
    | limit 20
  QUERY
}
