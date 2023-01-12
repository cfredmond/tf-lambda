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