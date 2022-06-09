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
        "name": "AWS_ACCESS_KEY_ID",
        "value": "${aws_access_key_id}"
      },
      {
        "name": "AWS_SECRET_ACCESS_KEY",
        "value": "${aws_secret_access_key}"
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
        "name": "AWS_ACCESS_KEY_ID",
        "valueFrom": "${aws_access_key_id_arn}"
      },
      {
        "name": "AWS_SECRET_ACCESS_KEY",
        "valueFrom": "${aws_secret_access_key_arn}"
      },
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