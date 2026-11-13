data "aws_caller_identity" "current" {}

# 앞선 루트의 outputs 를 읽음 — 루트 간 값 전달은 이 한 가지 방법만
data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "dev/network/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "data" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "dev/data/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "foundation" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "dev/foundation/terraform.tfstate"
    region = var.region
  }
}

# 담당자가 계정에 만들어 둔 컨트롤러 공용 정책 — 이름으로 ARN 조회
data "aws_iam_policy" "alb_controller" {
  name = var.alb_controller_policy_name
}

locals {
  account_id   = data.aws_caller_identity.current.account_id
  name_prefix  = "${var.team_id}-${var.environment}"
  cluster_name = "${local.name_prefix}-eks"
  boundary_arn = "arn:aws:iam::${local.account_id}:policy/Student-Boundary"

  net        = data.terraform_remote_state.network.outputs
  db         = data.terraform_remote_state.data.outputs
  foundation = data.terraform_remote_state.foundation.outputs

  # 모듈 · 시작 템플릿에 넘길 태그 — provider default_tags 는 시작 템플릿의 tag_specifications 에 닿지 않음
  tags = {
    Owner       = var.owner
    Team        = var.team_number
    Environment = var.environment
    Project     = "cafe"
    ManagedBy   = "terraform"
  }
}
