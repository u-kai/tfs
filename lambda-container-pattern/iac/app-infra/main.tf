resource "aws_lambda_function" "app_lambda" {
  function_name = "app-lambda"
  image_uri     = var.app_repo_url
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


