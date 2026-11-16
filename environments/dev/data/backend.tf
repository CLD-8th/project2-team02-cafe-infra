terraform {
  backend "s3" {
    bucket       = "team02-tfstate-20261113"
    key          = "dev/data/terraform.tfstate"
    region       = "ap-northeast-2"
    encrypt      = true
    use_lockfile = true
  }
}
