resource "aws_dynamodb_table" "crc_db" {
  name         = "CRC_DB"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "DB_ITEM"

  attribute {
    name = "DB_ITEM"
    type = "S"
  }

  tags = {
    "use" = "cloud_resume_challenge"
  }
}


resource "aws_dynamodb_table_item" "db_counter_item" {
  depends_on = [
    aws_dynamodb_table.crc_db
  ]
  table_name = aws_dynamodb_table.crc_db.name
  hash_key   = aws_dynamodb_table.crc_db.hash_key

  item = <<ITEM
    {
        "DB_ITEM": {
            "S" : "visitors"
        },
        "CALC_TOTAL":{
            "N" : "0"
        }
    }
    ITEM
}

resource "aws_iam_policy" "lambda_dynamodb" {
  name        = "CRC_Lambda_DynamoDB_Read_Write"
  description = "Policy to allow lambda function within the cloud resume challenge to read and write to dynamodb table holding visitor count"
  policy      = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1653887873838",
      "Action": [
        "dynamodb:DescribeTable",
        "dynamodb:GetItem",
        "dynamodb:ListTables",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:UpdateTable"
      ],
      "Effect": "Allow",
      "Resource": "${aws_dynamodb_table.crc_db.arn}"
    }
  ]
}
EOT
}

resource "aws_iam_role_policy_attachment" "lambda_dynamo_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_dynamodb.arn
}