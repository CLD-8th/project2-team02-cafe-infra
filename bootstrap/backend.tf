terraform {
  backend "s3" {
    bucket       = "team02-tfstate-20261112"
    key          = "bootstrap/terraform.tfstate"
    region       = "ap-northeast-2"
    encrypt      = true
    use_lockfile = true
  }
}
