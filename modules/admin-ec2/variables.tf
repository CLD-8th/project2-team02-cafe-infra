variable "name" {
  type        = string
  description = "인스턴스 · 역할 · 프로파일 · 보안 그룹 이름 (예: team02-dev-admin)"
}

variable "vpc_id" {
  type        = string
  description = "보안 그룹을 만들 VPC — network 루트의 vpc_id"
}

variable "subnet_id" {
  type        = string
  description = "프라이빗 서브넷 — network 루트의 private_subnet_ids[0]"
}

variable "permissions_boundary_arn" {
  type        = string
  description = "역할 권한 경계 — Student-Boundary ARN"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}
