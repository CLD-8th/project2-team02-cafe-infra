variable "name_prefix" {
  description = "AWS 리소스 이름 접두사"
  type        = string
}

variable "vpc_id" {
  description = "Security Group을 생성할 VPC ID"
  type        = string
}

variable "app_port" {
  description = "애플리케이션이 수신하는 TCP 포트"
  type        = number
  default     = 8080

  validation {
    condition     = var.app_port >= 1 && var.app_port <= 65535
    error_message = "app_port는 1~65535 범위여야 합니다."
  }
}

variable "db_port" {
  description = "MYSQL 포트"
  type        = number
  default     = 3306

  validation {
    condition     = var.db_port >= 1 && var.db_port <= 65535
    error_message = "db_port는 1~65535 범위여야 합니다."
  }
}