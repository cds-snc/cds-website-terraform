data "aws_caller_identity" "current" {}

resource "aws_kms_key" "cw" {
  description         = "KMS key 1"
  enable_key_rotation = true

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Id" : "key-default-1",
  "Statement" : [ {
      "Sid" : "Enable IAM User Permissions",
      "Effect" : "Allow",
      "Principal" : {
        "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action" : "kms:*",
      "Resource" : "*"
    },
    {
      "Effect": "Allow",
      "Principal": { "Service": "logs.ca-central-1.amazonaws.com" },
      "Action": [ 
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Allow_CloudWatch_for_CMK",
      "Effect": "Allow",
      "Principal": {
          "Service":[
              "cloudwatch.amazonaws.com"
          ]
      },
      "Action": [
          "kms:Decrypt","kms:GenerateDataKey"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "cds-website-cms" {
  name              = "ecs-cds-website-cms"
  kms_key_id        = aws_kms_key.cw.arn
  retention_in_days = 14
}