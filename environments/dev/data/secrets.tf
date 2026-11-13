# 앱 비밀 그릇 — 값(JWT_SECRET · STAFF_PASSWORD 등)은 apply 뒤 CLI 로 넣음 · 코드와 state 에 비밀 없음
resource "aws_secretsmanager_secret" "app" {
  name                    = "${var.team_id}/${var.environment}/cafe"
  description             = "cafe app secrets (JWT_SECRET, STAFF_PASSWORD)"
  recovery_window_in_days = 0
}
