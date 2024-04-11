[
  {
    "name": "cds-website-cms",
    "image": "${image}",
    "portMappings": [
      {
        "containerPort": 1337
      }
    ],
    "environment": [
      {
        "name": "NODE_ENV",
        "value": "production"
      },
      {
        "name": "DATABASE_HOST",
        "value": "${db_host}"
      },
      {
        "name": "BUCKET_NAME",
        "value": "${bucket_name}"
      },
      {
        "name": "DATABASE_USERNAME",
        "value": "${db_user}"
      }
    ],
    "secrets" : [
      {
        "name" : "DATABASE_PASSWORD",
        "valueFrom" : "${db_password_arn}"
      },
      {
        "name" : "TOKEN",
        "valueFrom" : "${github_token_arn}"
      },
      {
        "name": "ADMIN_JWT_SECRET",
        "valueFrom": "${admin_jwt_secret_arn}"
      },
      {
        "name": "API_TOKEN_SALT",
        "valueFrom": "${api_token_salt_arn}"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${awslogs-group}",
        "awslogs-region": "ca-central-1",
        "awslogs-stream-prefix": "ecs-cds-website-cms"
      }
    }
  }
]