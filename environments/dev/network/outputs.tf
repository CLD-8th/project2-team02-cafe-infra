# 다음 루트(data · eks)가 읽는 계약 — 이름 바꾸지 말 것
output "vpc_id" {
  description = "VPC ID — eks 루트"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "public 서브넷 2개 — ALB"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "private 서브넷 2개 — EKS Node"
  value       = module.network.private_subnet_ids
}

output "isolated_subnet_ids" {
  description = "isolated 서브넷 2개 — RDS (data 루트)"
  value       = module.network.isolated_subnet_ids
}

output "alb_sg_id" {
  description = "ALB 보안 그룹 — Ingress"
  value       = module.security.alb_sg_id
}

output "app_sg_id" {
  description = "app 보안 그룹 — EKS Node (ALB → 8080)"
  value       = module.security.app_sg_id
}

output "db_sg_id" {
  description = "db 보안 그룹 — RDS (app → 3306 · data 루트)"
  value       = module.security.db_sg_id
}