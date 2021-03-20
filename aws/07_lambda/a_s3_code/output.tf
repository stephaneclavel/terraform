output "bucket_name" {
  description = "code bucket name"
  value       = aws_s3_bucket.s3_bucket_lambda_code.id
}
