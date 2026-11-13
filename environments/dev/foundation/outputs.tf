# 다음 루트 · manifests 가 읽는 계약 — 이름 바꾸지 말 것
output "bucket_name" {
  description = "메뉴 사진 버킷 이름 — ConfigMap 의 버킷 이름"
  value       = module.images_bucket.id
}

output "bucket_arn" {
  description = "메뉴 사진 버킷 ARN — eks 루트의 앱 Pod 역할 정책(S3 menus/*)"
  value       = module.images_bucket.arn
}

output "ecr_repository_url" {
  description = "이미지 주소 앞부분 — manifests 의 newName"
  value       = module.ecr.repository_url
}