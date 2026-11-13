# 최신 Amazon Linux 2023 AMI ID — SSM 공개 파라미터에서 읽음 (AMI ID 하드코딩 0)
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# 신뢰 정책 — EC2 서비스가 이 역할을 맡음
data "aws_iam_policy_document" "ec2_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# 보안 그룹 — 인바운드 없음 (Session Manager 로만 접속) · network 에 관리용 SG 가 없어 모듈에서 만듦
resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "Admin EC2 - no inbound, Session Manager only"
  vpc_id      = var.vpc_id

  tags = { Name = "${var.name}-sg" }
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id
  description       = "Outbound (EKS API, SSM, packages)"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_iam_role" "this" {
  name                 = "${var.name}-ec2-role"
  assume_role_policy   = data.aws_iam_policy_document.ec2_trust.json
  permissions_boundary = var.permissions_boundary_arn

  tags = { Name = "${var.name}-ec2-role" }
}

# Session Manager — SSH · 키 페어 없이 접속
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# 조회 전용 인라인 정책 — eks:DescribeCluster 등
resource "aws_iam_role_policy" "inventory" {
  name   = "eks-describe"
  role   = aws_iam_role.this.id
  policy = file("${path.module}/files/admin-ec2-role-policy.json")
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-ec2-profile"
  role = aws_iam_role.this.name
}

resource "aws_instance" "this" {
  ami                         = nonsensitive(data.aws_ssm_parameter.al2023.value)
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.this.id]
  iam_instance_profile        = aws_iam_instance_profile.this.name
  associate_public_ip_address = false

  # kubectl · git 설치
  user_data                   = file("${path.module}/files/admin-ec2-user-data.sh")
  user_data_replace_on_change = true

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 8
    encrypted   = true
  }

  # 최신 AMI 가 나올 때마다 plan 에 교체(to destroy)가 뜨지 않게 함
  lifecycle {
    ignore_changes = [ami]
  }

  tags = { Name = var.name }
}
