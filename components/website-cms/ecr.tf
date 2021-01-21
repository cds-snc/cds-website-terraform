resource "aws_ecr_repository" "image-repository" {
  name      = "cds-website/cms"

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
              "description": "Keep last 20 images",
              "selection": {
                  "tagStatus": "tagged",
                  "tagPrefixList": ["v"],
                  "countType": "imageCountMoreThan",
                  "countNumber": 20
              },
              "action": {
                  "type": "expire"
              }
          }
      ]
  }
  EOF
  }

output "ecr_repository_url" {
  value = {
    for repo in aws_ecr_repository.image-repository :
    repo.name => repo.repository_url
  }
}