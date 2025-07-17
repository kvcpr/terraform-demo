module "lambda_app" {
  source = "../../modules/lambda_app"
  BASE_NAME = terraform.workspace
}
