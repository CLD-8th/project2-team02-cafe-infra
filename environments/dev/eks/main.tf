module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  # ---- 1 단계 클러스터 구성
  name               = local.cluster_name
  kubernetes_version = var.kubernetes_version

  iam_role_name                 = "${local.name_prefix}-eks-cluster-role"
  iam_role_use_name_prefix      = false
  iam_role_permissions_boundary = local.boundary_arn

  authentication_mode                      = "API"
  enable_cluster_creator_admin_permissions = true

  create_kms_key    = false
  encryption_config = null

  # ---- 2 단계 네트워킹
  vpc_id     = local.net.vpc_id
  subnet_ids = local.net.private_subnet_ids

  endpoint_private_access = true
  endpoint_public_access  = false

  # 관리용 EC2 → 443
  security_group_additional_rules = {
    admin_https = {
      description              = "admin EC2 to kube-apiserver"
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      type                     = "ingress"
      source_security_group_id = module.admin_ec2.security_group_id
    }
  }

  # 관리용 EC2 → Pod 8080 (Pod IP 로 직접 curl)
  node_security_group_additional_rules = {
    admin_app = {
      description              = "admin EC2 to Pod 8080"
      protocol                 = "tcp"
      from_port                = 8080
      to_port                  = 8080
      type                     = "ingress"
      source_security_group_id = module.admin_ec2.security_group_id
    }
  }

  # ---- 3 단계 관찰성 — 제어 플레인 로깅 끔
  enabled_log_types           = []
  create_cloudwatch_log_group = false

  # IRSA 용 OIDC 공급자 — 만들지 않음 (Pod Identity 만 사용)
  enable_irsa = false

  # ---- 4 단계 애드온
  addons = {
    vpc-cni = {
      before_compute = true
    }
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy     = {}
    coredns        = {}
    metrics-server = {}
    aws-ebs-csi-driver = {
      pod_identity_association = [
        {
          role_arn        = aws_iam_role.ebs_csi.arn
          service_account = "ebs-csi-controller-sa"
        }
      ]
    }
  }

  # ---- Access Entry — 관리용 EC2 역할 · 생성자는 enable_cluster_creator_admin_permissions
  access_entries = {
    admin_ec2 = {
      principal_arn = module.admin_ec2.role_arn
      type          = "STANDARD"

      policy_associations = {
        cluster_admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  # ---- Node Group
  eks_managed_node_groups = {
    app = {
      name            = "${local.name_prefix}-ng"
      use_name_prefix = false

      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = [var.node_instance_type]
      capacity_type  = "ON_DEMAND"

      min_size     = 0
      max_size     = 3
      desired_size = var.node_desired_size

      subnet_ids = local.net.private_subnet_ids

      labels = {
        role = "app"
      }

      iam_role_name                 = "${local.name_prefix}-eks-node-role"
      iam_role_use_name_prefix      = false
      iam_role_permissions_boundary = local.boundary_arn

      tags = local.tags
    }
  }

  tags = local.tags
}
