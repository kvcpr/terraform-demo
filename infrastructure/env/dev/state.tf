terraform {
  backend "s3" {
    bucket = "kp-tf-demo-terraform-state"
    key    = "dev-tf-state"
    region = "eu-central-1"
  }
}
