resource "aws_s3_bucket" "website-asset-bucket" {
  bucket = "cds-website-assets-prod"

  tags = {
    Name       = var.product_name
    CostCenter = var.product_name
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  #tfsec:ignore:AWS002 - No logging enabled
  #tfsec:ignore:AWS077 - no versioning
}

resource "aws_s3_bucket_policy" "website-asset-bucket" {
  bucket = aws_s3_bucket.website-asset-bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "OnlyCloudfrontReadAccess",
      "Principal": {
        "AWS": "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
      },
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "${aws_s3_bucket.website-asset-bucket.arn}/*"
    }
  ]
}
POLICY
}
