provider "aws" {
  region =var.aws_region
}
provider "archive" {}
data "archive_file" "zip" {
  type        = "zip"
  source_file = "welcome.py"
  output_path = "welcome.zip"
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.policy.json
}

resource "aws_lambda_function" "lambda_url" {
  function_name = "lambda_url"
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  role    = aws_iam_role.iam_for_lambda.arn
  handler = "welcome.lambda_url_test"
  runtime = "python3.10"
}

resource "aws_lambda_function_url" "lambda_function_url" {
    function_name = aws_lambda_function.lambda_url.arn
    authorization_type = "NONE"
}