output "endpoint" {
  description = "호스트 이름만 (포트 없음) — ConfigMap DB_URL"
  value       = aws_db_instance.this.address
}

output "port" {
  value = aws_db_instance.this.port
}

output "db_name" {
  value = aws_db_instance.this.db_name
}

output "secret_arn" {
  description = "RDS 관리형 마스터 암호의 Secrets Manager ARN — ESO 역할의 GetSecretValue 대상"
  value       = aws_db_instance.this.master_user_secret[0].secret_arn
}

output "arn" {
  value = aws_db_instance.this.arn
}
