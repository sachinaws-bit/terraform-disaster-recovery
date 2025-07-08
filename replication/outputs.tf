output "primary_bucket_name" {
  value = aws_s3_bucket.primary_bucket.bucket
}

output "dr_bucket_name" {
  value = aws_s3_bucket.dr_bucket.bucket
}