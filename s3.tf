resource "random_pet" "tf_lambda_bucket_name" {
  prefix = "tf-lambda"
  length = 4
}

resource "aws_s3_bucket" "tf_lambda_bucket" {
  bucket = random_pet.tf_lambda_bucket_name.id
}

resource "aws_s3_bucket_acl" "tf_lambda_bucket_acl" {
  bucket = aws_s3_bucket.tf_lambda_bucket.id
  acl    = "private"
}

data "archive_file" "example" {
  type = "zip"

  source_dir  = "${path.module}/example-dist"
  output_path = "${path.module}/example-dist.zip"
}

resource "aws_s3_object" "example" {
  bucket = aws_s3_bucket.tf_lambda_bucket.id

  key    = "example-dist.zip"
  source = data.archive_file.example.output_path

  etag = filemd5(data.archive_file.example.output_path)
}