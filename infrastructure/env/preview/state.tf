terraform {
  backend "s3" {
    bucket = "kp-tf-demo-terraform-state"
    key    = "preview-tf-state"
    region = "eu-central-1"
  }
}
