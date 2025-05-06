variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Base name for the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}
