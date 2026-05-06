terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

locals {
  name_prefix = "${var.project}-${var.env}"
}

resource "aws_iam_role" "terraform_execution" {
  name = "${local.name_prefix}-tf-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowAssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-tf-exec-role"
      Tier = "account-baseline"
    }
  )
}

resource "aws_iam_role_policy_attachment" "terraform_execution_admin" {
  role       = aws_iam_role.terraform_execution.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role" "readonly" {
  name = "${local.name_prefix}-readonly-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowAssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-readonly-role"
      Tier = "account-baseline"
    }
  )
}

resource "aws_iam_role_policy_attachment" "readonly_attach" {
  role       = aws_iam_role.readonly.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_cloudwatch_log_group" "baseline" {
  name              = "/${local.name_prefix}/baseline"
  retention_in_days = 14

  tags = merge(
    var.common_tags,
    {
      Name = "/${local.name_prefix}/baseline"
      Tier = "account-baseline"
    }
  )
}

resource "aws_ssm_parameter" "env_marker" {
  name  = "/${local.name_prefix}/env"
  type  = "String"
  value = var.env

  tags = merge(
    var.common_tags,
    {
      Name = "/${local.name_prefix}/env"
      Tier = "account-baseline"
    }
  )
}
