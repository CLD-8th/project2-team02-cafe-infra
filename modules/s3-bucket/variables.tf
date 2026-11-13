variable "bucket_name" {
  type        = string
  description = "버킷 이름 — 전 세계에서 유일해야 함"
}

variable "force_destroy" {
  type        = bool
  description = "true 면 객체가 있어도 destroy 때 버킷 삭제"
  default     = false
}

variable "noncurrent_days" {
  type        = number
  description = "이전 버전 객체를 지우기까지 일수"
  default     = 30
}

variable "abort_multipart_days" {
  type        = number
  description = "끝나지 않은 멀티파트 업로드를 정리하기까지 일수"
  default     = 7
}