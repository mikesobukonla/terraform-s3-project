provider "aws" {
  region = var.aws_region
}

module "s3_bucket" {
  source      = "./modules/s3_bucket_module"
  bucket_name = var.bucket_name
  environment = var.environment
}
