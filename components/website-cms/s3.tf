resource "aws_s3_bucket" "website-asset-bucket" {
  bucket = "cds-website-assets-prod"
  #tfsec:ignore:AWS001 - Public read access
  acl    = "public-read"

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
}