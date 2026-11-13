variable "team_id" {
  type        = string
  description = "팀 접두사 — 리소스 이름(team02-dev-*)"

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

variable "vpc_cidr" {
  type        = string
  description = "VPC 대역 — 10.202.0.0/16"
}

variable "enable_nat" {
  type        = bool
  description = "실습 시간 true · 실습 시간 외 false (NAT 삭제로 비용 절감)"
  default     = true
}

variable "single_nat" {
  type        = bool
  description = "true 면 NAT 1개(public-a) — 팀당 NAT 1개 규칙"
  default     = true
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "public 서브넷 2개 (a · c) — ALB · NAT"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "private 서브넷 2개 (a · c) — EKS Node"
}

variable "isolated_subnet_cidrs" {
  type        = list(string)
  description = "isolated 서브넷 2개 (a · c) — RDS"
}