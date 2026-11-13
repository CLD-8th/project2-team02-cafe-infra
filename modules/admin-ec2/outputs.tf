output "instance_id" {
  description = "Session Manager 대상 — aws ssm start-session --target"
  value       = aws_instance.this.id
}

output "role_arn" {
  description = "Access Entry 의 principal_arn"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  value = aws_iam_role.this.name
}

output "security_group_id" {
  description = "관리용 EC2 보안 그룹 — eks 루트의 443 · 8080 규칙 소스"
  value       = aws_security_group.this.id
}
