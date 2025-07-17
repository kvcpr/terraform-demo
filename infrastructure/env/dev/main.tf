locals {
  BASE_NAME = "dev"
}

module "lambda_app" {
  source = "../../modules/lambda_app"
  BASE_NAME = local.BASE_NAME
}


module "iam" {
  source = "../../modules/iam"
  BASE_NAME = local.BASE_NAME
}
