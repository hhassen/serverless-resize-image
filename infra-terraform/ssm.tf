resource "aws_ssm_parameter" "endpoint" {
  name        = "/${var.project}/s3/name"
  description = "${var.bucket_name} BUCKET NAME"
  type        = "String"
  value       = module.s3_bucket.s3_bucket_id
}