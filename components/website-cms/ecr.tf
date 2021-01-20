resource "aws_ecr_repository" "image-repository" {
  name      = "cds-website-cms-repository"

  image_scanning_configuration {
    scan_on_push = true
  }
}