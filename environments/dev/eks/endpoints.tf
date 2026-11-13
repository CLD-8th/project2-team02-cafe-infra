# ECR Interface Endpoint (선택) — 기본 false
# 비용 : Interface Endpoint 1개 = AZ 당 시간당 약 $0.0147 + 처리 GB 당 $0.01
#   api + dkr 2개 × 2 AZ = 시간당 약 $0.059 → 하루 약 $1.4 · 한 달 약 $42
# NAT : 처리 GB 당 $0.059 → 노드 2대 · 하루 이미지 pull 수 GB 수준이면 NAT 가 더 쌈
#   노드 30대 · 매일 수십 GB pull 이면 Endpoint 가 쌈 — 규모에 따라 결정 (교안 표)
resource "aws_security_group" "vpce" {
  count = var.enable_ecr_endpoint ? 1 : 0

  name        = "${local.name_prefix}-vpce-sg"
  description = "VPC interface endpoints - HTTPS from VPC"
  vpc_id      = local.net.vpc_id

  tags = { Name = "${local.name_prefix}-vpce-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "vpce_https" {
  count = var.enable_ecr_endpoint ? 1 : 0

  security_group_id = aws_security_group.vpce[0].id
  cidr_ipv4         = local.net.vpc_cidr
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_endpoint" "ecr" {
  for_each = var.enable_ecr_endpoint ? toset(["ecr.api", "ecr.dkr"]) : toset([])

  vpc_id              = local.net.vpc_id
  service_name        = "com.amazonaws.${var.region}.${each.key}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = local.net.private_subnet_ids
  security_group_ids  = [aws_security_group.vpce[0].id]
  private_dns_enabled = true

  tags = { Name = "${local.name_prefix}-${replace(each.key, ".", "-")}" }
}
