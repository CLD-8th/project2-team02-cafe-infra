output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "프라이빗 엔드포인트 — VPC 안(관리용 EC2)에서만 닿음"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "모듈이 만든 클러스터 SG (admin-sg -> 443 규칙)"
  value       = module.eks.cluster_security_group_id
}

output "node_security_group_id" {
  description = "노드 SG — db-sg 규칙의 소스"
  value       = module.eks.node_security_group_id
}

output "admin_instance_id" {
  description = "Session Manager 대상"
  value       = module.admin_ec2.instance_id
}

output "admin_role_arn" {
  value = module.admin_ec2.role_arn
}

output "pod_identity_roles" {
  description = "Pod Identity 역할 4종 — namespace/SA ↔ 역할 (매니페스트와 이름이 같아야 함)"
  value = {
    "kube-system/aws-load-balancer-controller" = aws_iam_role.alb_controller.arn
    "kube-system/ebs-csi-controller-sa"        = aws_iam_role.ebs_csi.arn
    "cafe/cafe"                                = aws_iam_role.app.arn
    "external-secrets/external-secrets"        = aws_iam_role.eso.arn
  }
}

output "kubeconfig_command" {
  description = "관리용 EC2 에서 실행"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}"
}
