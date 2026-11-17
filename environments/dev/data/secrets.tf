# 앱 비밀 그릇 — 값(JWT_SECRET · STAFF_PASSWORD 등)은 apply 뒤 CLI 로 넣음 · 코드와 state 에 비밀 없음
resource "aws_secretsmanager_secret" "app" {
  name                    = "${var.team_id}/${var.environment}/cafe"
  description             = "cafe app secrets (JWT_SECRET, STAFF_PASSWORD)"
  recovery_window_in_days = 0
}

# 모니터링 비밀 그릇 — 값(SLACK_WEBHOOK_URL · GRAFANA_ADMIN_PASSWORD)은 apply 뒤 CLI 로 넣음
resource "aws_secretsmanager_secret" "monitoring" {
  name                    = "${var.team_id}/${var.environment}/monitoring"
  description             = "monitoring secrets (SLACK_WEBHOOK_URL, GRAFANA_ADMIN_PASSWORD)"
  recovery_window_in_days = 0
}
