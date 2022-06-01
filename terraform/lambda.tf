data "archive_file" "lambda_counter" {
  type        = "zip"
  source_file = "../functions/increment_count.py"
  output_path = "${path.module}/lambda/cloud_challenge_increment_fnc.zip"
}

data "archive_file" "lambda_fetch" {
  type        = "zip"
  source_file = "../functions/fetch_count.py"
  output_path = "${path.module}/lambda/cloud_challenge_fetch_fnc.zip"
}

resource "aws_s3_object" "lambda_function" {
  bucket = aws_s3_bucket.cv_bucket.id
  key    = "cloud_challenge_increment_fnc.zip"
  source = data.archive_file.lambda_counter.output_path
}

resource "aws_s3_object" "lambda_function_fetch" {
  bucket = aws_s3_bucket.cv_bucket.id
  key    = "cloud_challenge_fetch_fnc.zip"
  source = data.archive_file.lambda_fetch.output_path
}

resource "aws_lambda_function" "lambda_visit_counter" {
  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy
  ]
  function_name    = "cloud_resume_challenge_increment"
  s3_bucket        = aws_s3_bucket.cv_bucket.id
  s3_key           = aws_s3_object.lambda_function.key
  runtime          = "python3.9"
  handler          = "increment_count.lambda_handler"
  source_code_hash = data.archive_file.lambda_counter.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn
  publish          = true

  environment {
    variables = {
      "TABLE_NAME" = "CRC_DB"
    }
  }
}

resource "aws_lambda_function" "lambda_visit_fetch" {
  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy
  ]
  function_name    = "cloud_resume_challenge_fetch"
  s3_bucket        = aws_s3_bucket.cv_bucket.id
  s3_key           = aws_s3_object.lambda_function_fetch.key
  runtime          = "python3.9"
  handler          = "fetch_count.lambda_handler"
  source_code_hash = data.archive_file.lambda_fetch.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      "TABLE_NAME" = "CRC_DB"
    }
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_cloudwatch_log_group" "lmbda_crc_visit_count" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_visit_counter.function_name}"
  retention_in_days = 30
}

resource "aws_iam_role_policy_attachment" "lambda_policy_fetch" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_cloudwatch_log_group" "lmbda_crc_fetch_count" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_visit_fetch.function_name}"
  retention_in_days = 30
}