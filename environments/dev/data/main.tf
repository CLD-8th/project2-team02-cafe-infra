# 같은 환경의 network 루트 state 를 읽음 — outputs 만 보임
data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "${var.environment}/network/terraform.tfstate"
    region = var.region
  }
}

locals {
  name_prefix = "${var.team_id}-${var.environment}"
  net         = data.terraform_remote_state.network.outputs
}

module "rds" {
  source = "../../../modules/rds-mysql"

  identifier         = "${local.name_prefix}-rds"
  subnet_ids         = local.net.isolated_subnet_ids
  security_group_ids = [local.net.db_sg_id]
  instance_class     = var.db_instance_class
  multi_az           = var.db_multi_az
  db_name            = "cafe"
}

