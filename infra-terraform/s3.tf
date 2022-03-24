module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.bucket_name
  acl    = "private"

  versioning = {
    enabled = true
  }

  tags = {
    project     = var.project
    managed_by  = var.managed_by
    environment = var.environment
  }
}