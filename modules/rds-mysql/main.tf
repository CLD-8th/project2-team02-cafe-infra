resource "aws_db_subnet_group" "this" {
  name       = "${var.identifier}-subnets"
  subnet_ids = var.subnet_ids
  tags       = { Name = "${var.identifier}-subnets" }
}

resource "aws_db_instance" "this" {
  identifier = var.identifier

  engine         = "mysql"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.allocated_storage * 2
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.username
  port     = 3306

  # 마스터 암호를 RDS 가 Secrets Manager 에 만들어 관리 — 코드 · state · Git 에 암호 없음 (콘솔 "AWS Secrets Manager 에서 관리" 와 같음)
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids
  publicly_accessible    = false
  multi_az               = var.multi_az

  backup_retention_period    = var.backup_retention_period
  auto_minor_version_upgrade = false
  apply_immediately          = true

  skip_final_snapshot = true
  deletion_protection = false

  tags = { Name = var.identifier }
}
