provider "aws" {
}

data "terraform_remote_state" "ecr" {
  backend = "s3"
  config = {
    bucket = "terraform-state-playground-kai"
    key    = "ecr/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

resource "aws_lambda_function" "app_lambda" {
  function_name = "app-lambda"
  image_uri     = "${data.terraform_remote_state.ecr.outputs.app_repo_url}:010cb23b3390e0043c67d51739a21767402687e3"
  package_type  = "Image"
  role          = aws_iam_role.app_lambda_role.arn

  environment {
    variables = {
      SECRET_KEY = var.secret_key
    }
  }
}

resource "aws_lambda_function" "service_a_lambda" {
  function_name = "service-a-lambda"
  image_uri     = data.terraform_remote_state.ecr.outputs.service_a_repo
  package_type  = "Image"
  role          = aws_iam_role.app_lambda_role.arn

  environment {
    variables = {
      SECRET_KEY = var.secret_key
    }
  }
}

resource "aws_lambda_function" "service_b_lambda" {
  function_name = "service-b-lambda"
  image_uri     = data.terraform_remote_state.ecr.outputs.service_b_repo
  package_type  = "Image"
  role          = aws_iam_role.app_lambda_role.arn

  environment {
    variables = {
      SECRET_KEY = var.secret_key
    }
  }
}

variable "secret_key" {
  type      = string
  sensitive = true
}

resource "aws_iam_role" "app_lambda_role" {
  name = "app-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy" "app_lambda_policy" {
  name   = "app-lambda-policy"
  role   = aws_iam_role.app_lambda_role.id
  policy = data.aws_iam_policy_document.app_lambda_policy.json
}

data "aws_iam_policy_document" "app_lambda_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorization",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_dynamodb_table" "app_table" {
  name         = "app-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  attribute {
    name = "id"
    type = "S"
  }
  range_key = "created_at"
  attribute {
    name = "created_at"
    type = "N"
  }
}


resource "aws_iam_role_policy" "app_lambda_policy2" {
  name   = "app-lambda-policy2"
  role   = aws_iam_role.app_lambda_role.id
  policy = data.aws_iam_policy_document.app_lambda_policy2.json
}

data "aws_iam_policy_document" "app_lambda_policy2" {
  statement {
    effect = "Allow"
    actions = [
      "dynodb:GetItem",
    ]
    resources = ["*"]
  }
}

