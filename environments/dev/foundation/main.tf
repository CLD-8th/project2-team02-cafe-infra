locals {
  images_bucket_name = "${var.team_id}-${var.environment}-images-${var.bucket_date}"
  ecr_repository     = "${var.team_id}/cafe"
}

# ---- S3 메뉴 사진 버킷 — 비공개 · 앱 Pod 만 Pod Identity 로 접근 (권한은 eks 루트)
module "images_bucket" {
  source = "../../../modules/s3-bucket"

  bucket_name   = local.images_bucket_name
  force_destroy = true
}

# ---- ECR team02/cafe — 태그 변경 불가(Immutable) · push 때 취약점 검사
module "ecr" {
  source = "../../../modules/ecr"

  name         = local.ecr_repository
  force_delete = true
}