#!/bin/bash

# Setup full Terraform project to manage an S3 bucket with versioning and lifecycle

PROJECT_ROOT="terraform-s3-project"
MODULE_NAME="s3_bucket_module"

echo "Creating project directory: $PROJECT_ROOT"
mkdir -p $PROJECT_ROOT/modules/$MODULE_NAME
cd $PROJECT_ROOT

#############################
# Root main.tf
#############################
echo "Generating root main.tf"
cat > main.tf << EOF
provider "aws" {
  region = var.aws_region
}

module "s3_bucket" {
  source      = "./modules/$MODULE_NAME"
  bucket_name = var.bucket_name
  environment = var.environment
}
EOF

#############################
# Root variables.tf
#############################
echo "Generating root variables.tf"
cat > variables.tf << EOF
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
EOF

#############################
# Root terraform.tfvars
#############################
echo "Generating root terraform.tfvars"
cat > terraform.tfvars << EOF
bucket_name  = "my-devops-bucket"
environment  = "dev"
aws_region   = "us-east-1"
EOF

cd modules/$MODULE_NAME

#############################
# Module: main.tf
#############################
echo "Generating module main.tf"
cat > main.tf << 'EOF'
resource "aws_s3_bucket" "this" {
  bucket = "${var.bucket_name}-${var.environment}-${random_id.suffix.hex}"
  force_destroy = true

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "auto-delete"
    status = "Enabled"

    expiration {
      days = 30
    }

    noncurrent_version_expiration {
      days = 30
    }

    filter {}
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}
EOF

#############################
# Module: variables.tf
#############################
echo "Generating module variables.tf"
cat > variables.tf << 'EOF'
variable "bucket_name" {
  description = "Base name for the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}
EOF

#############################
# Module: outputs.tf
#############################
echo "Generating module outputs.tf"
cat > outputs.tf << 'EOF'
output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}
EOF

echo "✅ Terraform project setup complete!"
