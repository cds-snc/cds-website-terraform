resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "cloudfront origin access identity"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
      domain_name = aws_s3_bucket.website-asset-bucket.bucket_regional_domain_name
      origin_id = local.s3_origin_id

      s3_origin_config {
          origin_access_identity = "origin_access_identity"
      }
  }

  enabled         = true
  is_ipv6_enabled = true
  #tfsec:ignore:AWS045 - No WAF

  default_cache_behavior {
    path_pattern     = "*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward      = "none"
      }
    }

    viewer_protocol_policy = "https-only"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version = "TLSv1.2_2019"
  }
}