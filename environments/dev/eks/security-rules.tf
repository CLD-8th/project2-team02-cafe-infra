# Pod(노드 SG) → RDS 3306 — 구성도의 "db-sg 에 클러스터 SG 규칙"
# 규칙의 소유자가 eks 루트이므로 destroy 때 클러스터 SG 보다 먼저 지워짐 (참조 규칙 잔존 함정 해결)
# description 에는 영문 · 숫자 · ._-:/()#,@[]+=&;{}!$* 만 (">" · 한글 불가 — apply 때 AWS 가 거부)
resource "aws_vpc_security_group_ingress_rule" "db_from_nodes" {
  security_group_id            = local.net.db_sg_id
  referenced_security_group_id = module.eks.node_security_group_id
  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
  description                  = "EKS nodes (Pod) to MySQL"

  tags = { Name = "${local.name_prefix}-db-from-eks-nodes" }
}
