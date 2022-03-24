variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = ""
}

variable "managed_by" {
  type        = string
  default     = "terraform"
  description = "tool managing the resource"
}

variable "bucket_name" {
  type        = string
  description = "Bucket name for the project"
}