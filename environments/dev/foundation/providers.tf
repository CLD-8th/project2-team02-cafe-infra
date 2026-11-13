provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Owner       = var.owner
      Team        = var.team_number
      Environment = var.environment
      Project     = "cafe"
      ManagedBy   = "terraform"
    }
  }
}