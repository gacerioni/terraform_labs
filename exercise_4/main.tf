provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
}

terraform {
   backend "s3" {
   bucket = "gabs-remote-tf-state-bucket"
   key = "terraform-lab4.tfstate"
   region = "us-east-2"
  }
}

resource "aws_s3_bucket" "tf-root-module-bucket" {
  bucket = var.s3_bucket_name
  acl = "private"
  
  versioning {
    enabled = true
  }
  
  tags = {
    Name        = var.s3_bucket_name
    Environment = var.tag_env
  }
}
