terraform {
  experiments = [module_variable_optional_attrs]
  required_version = ">= 1.3.6"

  required_providers {
    aws = {
      version = ">= 4.48.0"
      source = "hashicorp/aws"
    }
  }
}