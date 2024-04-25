resource "aws_scheduler_schedule_group" "scheduler_group" {
  name = "scheduler-group"
}

resource "aws_scheduler_schedule" "app_scheduler" {
  name                = "app-scheduler"
  schedule_expression = "rate(1 minute)"
  flexible_time_window {
    mode = "OFF"
  }
  group_name = aws_scheduler_schedule_group.scheduler_group.name
  target {
    arn      = aws_lambda_function.app_lambda.arn
    role_arn = aws_iam_role.event_scheduler_role.arn
  }
}


resource "aws_iam_role" "event_scheduler_role" {
  name = "event-scheduler-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "events.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "event_scheduler_policy" {
  name   = "event-scheduler-policy"
  role   = aws_iam_role.event_scheduler_role.id
  policy = data.aws_iam_policy_document.event_scheduler_policy.json
}

data "aws_iam_policy_document" "event_scheduler_policy" {
  statement {
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = [aws_lambda_function.app_lambda.arn]
  }
}

module "ecr" {
  source = "../ecr"
}

resource "aws_lambda_function" "app_lambda" {
  function_name = "app-lambda"
  image_uri     = module.ecr.app_repo_url
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

