variable "team_id" {
  type        = string
  description = "팀 접두사 — 리소스 이름(team02-dev-*) · ECR(team02/cafe)"

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

variable "bucket_date" {
  type        = string
  description = "버킷을 만든 날짜 — S3 이름은 전 세계에서 유일해야 해서 붙임"
  default     = "20261113"
}