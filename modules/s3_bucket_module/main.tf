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
      noncurrent_days = 30
    }

    filter {
      prefix = ""
    }
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}
