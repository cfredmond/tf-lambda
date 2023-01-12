resource "random_pet" "lambda_bucket_name" {
  prefix = "bme280-api"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

data "archive_file" "lambda_bme280_save_reading" {
  type = "zip"

  source_dir  = "${path.module}/bme280-save-reading"
  output_path = "${path.module}/bme280-save-reading.zip"
}

resource "aws_s3_object" "lambda_bme280_save_reading" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "bme280-save-reading.zip"
  source = data.archive_file.lambda_bme280_save_reading.output_path

  etag = filemd5(data.archive_file.lambda_bme280_save_reading.output_path)
}

resource "aws_lambda_function" "bme280_save_reading" {
  function_name = "Bme280SaveReadingIaC"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_bme280_save_reading.key

  runtime = "nodejs16.x"
  handler = "Bme280SaveReading.handler"

  source_code_hash = data.archive_file.lambda_bme280_save_reading.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.bme280_save_reading.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
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

resource "aws_iam_role_policy" "dynamodb_policy" {
  name = "dynamodb_policy"
  role = aws_iam_role.lambda_exec.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid = "VisualEditor0"
      Effect = "Allow"
      Action = "dynamodb:PutItem"
      Resource = "arn:aws:dynamodb:us-east-1:525067006432:table/Bme280v2"
    }]
  })  
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_cloudwatch_log_group" "bme280_save_reading" {
  name = "/aws/lambda/${aws_lambda_function.bme280_save_reading.function_name}"

  retention_in_days = 30
}