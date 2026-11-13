locals {
  images_bucket_name = "${var.team_id}-${var.environment}-images-${var.bucket_date}"
  ecr_repository     = "${var.team_id}/cafe"
}

# ---- S3 메뉴 사진 버킷 — 비공개 · 앱 Pod 만 Pod Identity 로 접근 (권한은 eks 루트)
resource "aws_s3_bucket" "images" {
  bucket        = local.images_bucket_name
  force_destroy = true

  tags = {
    Name = local.images_bucket_name
  }
}

resource "aws_s3_bucket_versioning" "images" {
  bucket = aws_s3_bucket.images.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "images" {
  bucket = aws_s3_bucket.images.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "images" {
  bucket                  = aws_s3_bucket.images.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "images" {
  bucket = aws_s3_bucket.images.id

  rule {
    id     = "expire-old-versions"
    status = "Enabled"
    filter {}

    # 사진을 바꾸면 이전 판은 30일 뒤 삭제
    noncurrent_version_expiration {
      noncurrent_days = 30
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  depends_on = [aws_s3_bucket_versioning.images]
}

# ---- ECR team02/cafe — 태그 변경 불가(Immutable) · push 때 취약점 검사
resource "aws_ecr_repository" "app" {
  name                 = local.ecr_repository
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name = local.ecr_repository
  }
}