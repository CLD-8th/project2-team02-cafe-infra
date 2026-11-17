# 역할 4종의 공통 신뢰 정책 — 우리 계정 · 우리 클러스터의 Pod 만 맡을 수 있음
data "aws_iam_policy_document" "pod_identity_trust" {
  statement {
    sid     = "AllowEksPodIdentity"
    effect  = "Allow"
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.account_id]
    }

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:eks:${var.region}:${local.account_id}:cluster/${local.cluster_name}"]
    }
  }
}

# ---- ① ALB Controller 역할 — 계정 공용 정책 연결
resource "aws_iam_role" "alb_controller" {
  name                 = "${local.name_prefix}-alb-controller-role"
  assume_role_policy   = data.aws_iam_policy_document.pod_identity_trust.json
  permissions_boundary = local.boundary_arn

  tags = { Name = "${local.name_prefix}-alb-controller-role" }
}

resource "aws_iam_role_policy_attachment" "alb_controller" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = data.aws_iam_policy.alb_controller.arn
}

resource "aws_eks_pod_identity_association" "alb_controller" {
  cluster_name    = module.eks.cluster_name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.alb_controller.arn
}

# ---- ② EBS CSI 역할 — 연결은 main.tf 의 addons.aws-ebs-csi-driver.pod_identity_association
resource "aws_iam_role" "ebs_csi" {
  name                 = "${local.name_prefix}-ebs-csi-role"
  assume_role_policy   = data.aws_iam_policy_document.pod_identity_trust.json
  permissions_boundary = local.boundary_arn

  tags = { Name = "${local.name_prefix}-ebs-csi-role" }
}

# V2 는 경로 service-role/ 이 없음 (V1 만 …/service-role/AmazonEBSCSIDriverPolicy)
resource "aws_iam_role_policy_attachment" "ebs_csi" {
  role       = aws_iam_role.ebs_csi.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEBSCSIDriverPolicyV2"
}

# ---- ③ 앱 역할 — 메뉴 사진 버킷의 menus/* 만 (foundation 출력 bucket_arn)
data "aws_iam_policy_document" "app" {
  statement {
    sid       = "MenuImagesList"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [local.foundation.bucket_arn]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["menus/*"]
    }
  }

  statement {
    sid       = "MenuImagesObjects"
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${local.foundation.bucket_arn}/menus/*"]
  }
}

resource "aws_iam_role" "app" {
  name                 = "${local.name_prefix}-cafe-pod-role"
  assume_role_policy   = data.aws_iam_policy_document.pod_identity_trust.json
  permissions_boundary = local.boundary_arn

  tags = { Name = "${local.name_prefix}-cafe-pod-role" }
}

resource "aws_iam_role_policy" "app" {
  name   = "cafe-pod-policy"
  role   = aws_iam_role.app.id
  policy = data.aws_iam_policy_document.app.json
}

# namespace · ServiceAccount 이름은 매니페스트와 같아야 함
resource "aws_eks_pod_identity_association" "app" {
  cluster_name    = module.eks.cluster_name
  namespace       = "cafe"
  service_account = "cafe"
  role_arn        = aws_iam_role.app.arn
}

# ---- ④ ESO 역할 — 비밀 3개만 읽기 (RDS 관리형 암호 · 앱 · 모니터링 비밀 그릇 · data 출력)
data "aws_iam_policy_document" "eso" {
  statement {
    sid    = "ReadAppSecrets"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]
    resources = [
      local.db.rds_secret_arn,
      local.db.app_secret_arn,
      local.db.monitoring_secret_arn,
    ]
  }
}

resource "aws_iam_role" "eso" {
  name                 = "${local.name_prefix}-eso-role"
  assume_role_policy   = data.aws_iam_policy_document.pod_identity_trust.json
  permissions_boundary = local.boundary_arn

  tags = { Name = "${local.name_prefix}-eso-role" }
}

resource "aws_iam_role_policy" "eso" {
  name   = "eso-read-secrets"
  role   = aws_iam_role.eso.id
  policy = data.aws_iam_policy_document.eso.json
}

resource "aws_eks_pod_identity_association" "eso" {
  cluster_name    = module.eks.cluster_name
  namespace       = "external-secrets"
  service_account = "external-secrets"
  role_arn        = aws_iam_role.eso.arn
}
