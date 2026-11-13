# eks 루트 · ConfigMap · ExternalSecret 이 읽는 계약
output "rds_endpoint" {
  description = "ConfigMap DB_URL 의 호스트"
  value       = module.rds.endpoint
}

output "rds_port" {
  value = module.rds.port
}

output "rds_db_name" {
  value = module.rds.db_name
}

output "rds_secret_arn" {
  description = "RDS 관리형 암호 ARN — eks 루트 ESO 역할의 Resource · ExternalSecret 이 읽음"
  value       = module.rds.secret_arn
}
