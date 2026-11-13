module "admin_ec2" {
  source = "../../../modules/admin-ec2"

  name                     = "${local.name_prefix}-admin"
  vpc_id                   = local.net.vpc_id
  subnet_id                = local.net.private_subnet_ids[0]
  permissions_boundary_arn = local.boundary_arn
}
