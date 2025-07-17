data "archive_file" "codebase" {
  type        = "zip"
  source_file = "${path.module}/../../../code.js"
  output_path = "${path.module}/code.zip"
}

# IAM role for Lambda execution
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }

  statement {
    effect = "Allow"
    actions = ["kms:Decrypt"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.BASE_NAME}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_function" "app" {
  depends_on    = [
    data.archive_file.codebase,
    aws_iam_role.lambda_role,
  ]

  function_name = "${var.BASE_NAME}-app"
  role          = aws_iam_role.lambda_role.arn
  handler       = "code.handler"
  runtime       = "nodejs20.x"
  filename      = "${path.module}/code.zip"

  environment {
    variables = {
      ENV_NAME = var.BASE_NAME
    }
  }
}

resource "aws_lambda_function_url" "function_url" {
  depends_on = [aws_lambda_function.app]

  function_name      = aws_lambda_function.app.function_name
  authorization_type = "NONE"

  cors {
    allow_origins = ["*"]
    allow_methods = ["*"]
  }
}

