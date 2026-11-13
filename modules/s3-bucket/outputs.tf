output "id" {
  description = "버킷 이름"
  value       = aws_s3_bucket.this.id
}

output "arn" {
  description = "버킷 ARN"
  value       = aws_s3_bucket.this.arn
}