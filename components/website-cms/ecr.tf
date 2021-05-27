resource "aws_ecr_repository" "image-repository" {
  name = "cds-website/cms"

  #tfsec:ignore:AWS078 - no image_tag_mutability attribute
  #tfsec:ignore:AWS093 - no CMK encryption

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "policy" {
  repository = aws_ecr_repository.image-repository.name

  policy = <<EOF
  {
      "rules": [
          {
              "rulePriority": 1,
              "description": "Keep last 10 images",
              "selection": {
                  "tagStatus": "tagged",
                  "tagPrefixList": ["v"],
                  "countType": "imageCountMoreThan",
                  "countNumber": 10
              },
              "action": {
                  "type": "expire"
              }
          }
      ]
  }
  EOF
}
