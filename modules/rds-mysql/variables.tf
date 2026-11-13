variable "identifier" {
  type        = string
  description = "DB 인스턴스 식별자 (예: team02-dev-rds)"
}

variable "subnet_ids" {
  type        = list(string)
  description = "격리 서브넷 둘 — DB 서브넷 그룹"
}

variable "security_group_ids" {
  type        = list(string)
  description = "db 보안 그룹 — app 에서 오는 3306 만 허용"
}

variable "db_name" {
  type    = string
  default = "cafe"
}

variable "username" {
  type    = string
  default = "admin"
}

variable "engine_version" {
  type    = string
  default = "8.4"
}

variable "instance_class" {
  type    = string
  default = "db.t4g.micro"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "multi_az" {
  type        = bool
  description = "ADR-03 — 장애 시 대기 인스턴스로 자동 전환"
  default     = true
}

variable "backup_retention_period" {
  type        = number
  description = "자동 백업 보존 일수 — 특정 시점 복원(RPO 5분)"
  default     = 7
}
