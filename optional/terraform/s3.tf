################################################################################
# S3
################################################################################

resource "aws_s3_bucket" "private" {
  acl = "private"

  versioning {
    enabled = true
  }

  # Use a few characters to ensure uniqueness
  bucket = "secoda-private-${random_string.random.result}"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "random_string" "random" {
  length  = 6
  special = false
}
