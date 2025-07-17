provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      ManagedBy       = "Terraform"
      Environment     = "development"
    }
  }
}
