output "vpc_id" {
  description = "생성된 VPC ID"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "VPC CIDR"
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "Public Subnet ID 목록"
  value = [
    for az in var.azs :
    aws_subnet.public[az].id
  ]
}

output "private_subnet_ids" {
  description = "Private Subnet ID 목록"
  value = [
    for az in var.azs :
    aws_subnet.private[az].id
  ]
}

output "isolated_subnet_ids" {
  description = "Isolated Subnet ID 목록"
  value = [
    for az in var.azs :
    aws_subnet.isolated[az].id
  ]
}
