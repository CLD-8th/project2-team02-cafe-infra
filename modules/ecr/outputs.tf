output "repository_url" {
  description = "이미지 주소 앞부분"
  value       = aws_ecr_repository.this.repository_url
}

output "arn" {
  description = "리포지토리 ARN"
  value       = aws_ecr_repository.this.arn
}