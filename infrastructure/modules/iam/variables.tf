variable "BASE_NAME" {
  type        = string
  description = "Base name to be use in resources name"

  validation {
    condition     = can(regex("^(dev|prod|staging)$", var.BASE_NAME))
    error_message = "Base name can be one of dev, prod, staging"
  }
}
