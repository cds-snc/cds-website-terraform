resource "aws_wafv2_web_acl" "cms" {
  name  = "cms-waf"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "GeolocationRule"
    priority = 0

    action {
      block {}
    }

    statement {
      not_statement {
        statement {
          geo_match_statement {
            country_codes = ["CA", "US"]
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "GeolocationRule"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "RateLimitRule"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitRule"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        # Exclude problematic rules if needed
        rule_action_override {
          action_to_use {
            allow {}
          }
          name = "EC2MetaDataSSRF_BODY"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # AWS Managed Rules - Known Bad Inputs
  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "cms-waf"
    sampled_requests_enabled   = true
  }

  tags = {
    Name       = "${var.product_name}-waf"
    CostCenter = var.product_name
  }
}

# Associate WAF with ALB
resource "aws_wafv2_web_acl_association" "cms_alb" {
  resource_arn = aws_alb.cms-load-balancer.arn
  web_acl_arn  = aws_wafv2_web_acl.cms.arn
}

# WAF logging configuration
resource "aws_wafv2_web_acl_logging_configuration" "cms" {
  resource_arn            = aws_wafv2_web_acl.cms.arn
  log_destination_configs = [aws_kinesis_firehose_delivery_stream.waf_logs.arn]
}

# Kinesis Firehose for WAF logs
resource "aws_kinesis_firehose_delivery_stream" "waf_logs" {
  name        = "aws-waf-logs-cms"
  destination = "extended_s3"

  server_side_encryption {
    enabled = true
  }

  extended_s3_configuration {
    role_arn           = aws_iam_role.waf_logs.arn
    prefix             = "waf_logs/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
    bucket_arn         = aws_s3_bucket.logs.arn
    compression_format = "GZIP"
  }

  tags = {
    Name       = "${var.product_name}-waf-logs"
    CostCenter = var.product_name
  }
}

# IAM role for WAF logging
resource "aws_iam_role" "waf_logs" {
  name = "cms-waf-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name       = "${var.product_name}-waf-logs-role"
    CostCenter = var.product_name
  }
}

resource "aws_iam_role_policy" "waf_logs" {
  name = "waf-logs-policy"
  role = aws_iam_role.waf_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ]
        Resource = [
          aws_s3_bucket.logs.arn,
          "${aws_s3_bucket.logs.arn}/*"
        ]
      }
    ]
  })
}