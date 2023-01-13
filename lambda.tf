resource "aws_lambda_function" "example" {
  function_name = "example"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.example.key

  runtime = "python3.9"
  handler = "example.handler"

  source_code_hash = data.archive_file.example.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}