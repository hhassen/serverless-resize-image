terraform {
  backend "s3" {
    bucket = "tfstate-backend-hhassen-2022"
    key    = "tfstate/resize-image.tfstate"
    region = "us-east-1"
  }
}
