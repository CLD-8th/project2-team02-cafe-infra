
variable "name_prefix" {
  description = "AWS 리소스 이름 접두사"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "azs" {
  description = "Subnet을 생성할 가용 영역 목록"
  type        = list(string)

  validation {
    condition     = length(var.azs) == 2 && length(distinct(var.azs)) == 2
    error_message = "서로 다른 AZ 2개를 입력해야 합니다."
  }
}

variable "public_subnet_cidrs" {
  description = "Public Subnet CIDR 목록"
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) == length(var.azs)
    error_message = "Public Subnet CIDR 개수는 AZ 개수와 같아야 합니다."
  }
}

variable "private_subnet_cidrs" {
  description = "Private Subnet CIDR 목록"
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) == length(var.azs)
    error_message = "Private Subnet CIDR 개수는 AZ 개수와 같아야 합니다."
  }
}

variable "isolated_subnet_cidrs" {
  description = "Isolated Subnet CIDR 목록"
  type        = list(string)

  validation {
    condition     = length(var.isolated_subnet_cidrs) == length(var.azs)
    error_message = "Isolated Subnet CIDR 개수는 AZ 개수와 같아야 합니다."
  }
}

variable "enable_nat" {
  description = "NAT Gateway 생성 여부"
  type        = bool
  default     = true
}

variable "single_nat" {
  description = "단일 NAT Gateway 사용 여부"
  type        = bool
  default     = true

  validation {
    condition     = var.single_nat
    error_message = "현재 Network 모듈은 단일 NAT Gateway만 지원합니다."
  }
}

variable "cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string
}
