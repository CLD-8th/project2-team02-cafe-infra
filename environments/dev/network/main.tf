data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name_prefix  = "${var.team_id}-${var.environment}"
  cluster_name = "${var.team_id}-${var.environment}-eks"

  # 서울 리전 가용 영역 중 a · c 두 개만 사용
  azs = [for az in data.aws_availability_zones.available.names : az if endswith(az, "a") || endswith(az, "c")]
}

# ---- VPC · 서브넷 6 (public · private · isolated × a · c) · IGW · NAT 1 · 라우팅 · EKS 태그
module "network" {
  source = "../../../modules/network"

  name_prefix           = local.name_prefix
  vpc_cidr              = var.vpc_cidr
  azs                   = local.azs
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  isolated_subnet_cidrs = var.isolated_subnet_cidrs
  enable_nat            = var.enable_nat
  single_nat            = var.single_nat
  cluster_name          = local.cluster_name
}

# ---- 보안 그룹 3 (alb · app · db) — ALB → app 8080 → db 3306
module "security" {
  source = "../../../modules/security"

  name_prefix = local.name_prefix
  vpc_id      = module.network.vpc_id
}