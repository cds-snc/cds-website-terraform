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
        "name": DATABASE_HOST,
        "value": "${db_host}"
      },
    ]
  }
]