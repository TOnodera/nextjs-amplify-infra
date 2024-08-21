provider "aws" {
    region = "ap-northeast-1"
    default_tags {
      tags = {
        "Service" = "app"
        "Description" = "Maneged by terraform"
        "CreatedByRole" = "terraform"
      }
    }
}

terraform {
  required_version = ">=1.7.0"
    backend "s3" {
        bucket = "nextjs-terraform-onodera-1215"
        key = "app/service/production/terraform.tfstate"
        region = "ap-northeast-1"
    }
}