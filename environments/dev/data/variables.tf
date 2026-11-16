variable "team_id" {
  type        = string
  description = "팀 접두사 — 리소스 이름(team02-dev-*) · 비밀(team02/dev/*)"

  validation {
    condition     = can(regex("^team0[1-6]$", var.team_id))
    error_message = "team_id 는 team01 ~ team06."
  }
}

variable "owner" {
  type        = string
  description = "apply 하는 사람의 student_id — Owner 태그"

  validation {
    condition     = can(regex("^[a-z]{3}[0-9]{2}$", var.owner))
    error_message = "owner 는 소문자 3자 + 숫자 2자리 (예: kdh01 · cld00)."
  }
}

variable "team_number" {
  type        = string
  description = "PROJECT 2 팀 번호 — Team 태그 값(22) · 문자열"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "region" {
  type    = string
  default = "ap-northeast-2"
}

variable "state_bucket" {
  type        = string
  description = "network 루트의 state 가 있는 팀 버킷"
  default     = "team02-tfstate-20261113"
}

variable "db_instance_class" {
  type    = string
  default = "db.t4g.micro"
}

variable "db_multi_az" {
  type        = bool
  description = "ADR-03 — 장애 시 대기 인스턴스로 자동 전환"
  default     = true
}
