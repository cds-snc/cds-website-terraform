resource "aws_s3_bucket" "website-asset-bucket" {
  bucket = "cds-website-assets"
  #tfsec:ignore:AWS001 - Public read access
  acl    = "public-read"

  tags = {
    Name        = "CDS Website Assets"
  }

  #tfsec:ignore:AWS002 - No logging enabled
  #tfsec:ignore:AWS017 - Defines an unencrypted S3 bucket
}