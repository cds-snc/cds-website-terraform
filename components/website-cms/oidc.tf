locals {
  plan_name   = "gh_plan_role"
  admin_name  = "gh_admin_role"
  deploy_name = "gh_deploy_role"
}


module "oidc" {
  source            = "github.com/cds-snc/terraform-modules?ref=v2.0.1//gh_oidc_role"
  billing_tag_key   = "CostCentre"
  billing_tag_value = var.product_name
  oidc_exists       = true
  roles = [
    {
      name : local.admin_name,
      repo_name : "cds-website-terraform"
      claim : "ref:refs/heads/main"
    },
    {
      name : local.plan_name,
      repo_name : "cds-website-terraform"
      claim : "pull_request"
    },
    {
      name : local.deploy_name,
      repo_name : "cds-website-cms"
      claim : "ref:refs/heads/main"
    }
  ]
}

data "aws_iam_policy" "readonly" {
  name = "ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "readonly" {
  role       = local.plan_name
  policy_arn = data.aws_iam_policy.readonly.arn
}

## Least-privilege state access for the plan role: read-only on the state bucket and
## lock/unlock on the dynamodb lock table. 
data "aws_iam_policy_document" "plan_state_access" {
  statement {
    sid       = "ReadStateObjects"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.product_name}-tf/*"]
  }

  statement {
    sid       = "ListStateBucket"
    effect    = "Allow"
    actions   = ["s3:ListBucket", "s3:GetBucketLocation"]
    resources = ["arn:aws:s3:::${var.product_name}-tf"]
  }

  statement {
    sid     = "StateLockTable"
    effect  = "Allow"
    actions = ["dynamodb:DescribeTable", "dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem"]
    resources = [
      "arn:aws:dynamodb:${var.region}:${var.account_id}:table/terraform-state-lock-dynamo"
    ]
  }
}

resource "aws_iam_policy" "plan_state_access" {
  name   = "${local.plan_name}_state_access"
  policy = data.aws_iam_policy_document.plan_state_access.json

  tags = {
    CostCentre = var.product_name
  }
}

resource "aws_iam_role_policy_attachment" "plan_state_access" {
  role       = local.plan_name
  policy_arn = aws_iam_policy.plan_state_access.arn
}

data "aws_iam_policy" "admin" {
  name = "AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "admin" {
  role       = local.admin_name
  policy_arn = data.aws_iam_policy.admin.arn
}

data "aws_iam_policy" "ecs" {
  name = "AmazonECS_FullAccess"
}

data "aws_iam_policy" "ecr" {
  name = "AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "deploy_ecs" {
  role       = local.deploy_name
  policy_arn = data.aws_iam_policy.ecs.arn
}

resource "aws_iam_role_policy_attachment" "deploy_ecr" {
  role       = local.deploy_name
  policy_arn = data.aws_iam_policy.ecr.arn
}
