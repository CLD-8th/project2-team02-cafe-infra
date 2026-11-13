variable "name" {
  type        = string
  description = "리포지토리 이름 (예: team02/cafe)"
}

variable "image_tag_mutability" {
  type        = string
  description = "IMMUTABLE 이면 같은 태그로 다시 push 불가"
  default     = "IMMUTABLE"
}

variable "scan_on_push" {
  type        = bool
  description = "push 때 취약점 검사"
  default     = true
}

variable "force_delete" {
  type        = bool
  description = "true 면 이미지가 있어도 destroy 때 삭제"
  default     = false
}