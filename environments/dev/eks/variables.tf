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

variable "state_bucket" {
  type        = string
  description = "state 버킷 — remote_state 가 읽는 곳 (backend.tf 와 같은 값)"
  default     = "team02-tfstate-20261112"
}

variable "kubernetes_version" {
  type    = string
  default = "1.36"
}

variable "node_instance_type" {
  type        = string
  description = "ADR-04"
  default     = "t3.medium"
}

variable "node_desired_size" {
  type        = number
  default     = 2
  description = "처음 생성 때 노드 수 — 이후 축소 · 복구는 CLI (모듈이 desired_size 변경을 무시 · min 0 · max 3 은 고정)"
}

variable "enable_ecr_endpoint" {
  type        = bool
  default     = false
  description = "ECR Interface Endpoint 2개(api · dkr) — 시간당 과금 · 기본 false (NAT 경유)"
}

variable "alb_controller_policy_name" {
  type        = string
  default     = "AWSLoadBalancerControllerIAMPolicy"
  description = "계정 공용 고객 관리형 정책 이름 — 담당자가 미리 생성"
}
