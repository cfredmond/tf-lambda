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

data "archive_file" "example" {
  type = "zip"

  source_dir  = "${path.module}/example"
  output_path = "${path.module}/example.zip"
}

resource "aws_s3_object" "example" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "example.zip"
  source = data.archive_file.example.output_path

  etag = filemd5(data.archive_file.example.output_path)
}

resource "aws_lambda_function" "example" {
  function_name = "example"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.example.key

  runtime = "nodejs16.x"
  handler = "example.handler"

  source_code_hash = data.archive_file.example.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_iam_role" "lambda_exec" {
  name = "example"

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

resource "aws_cloudwatch_log_group" "example" {
  name = "/aws/lambda/${aws_lambda_function.example.function_name}"

  retention_in_days = 30
}