terraform {
    required_version = "~>1.14.0"
    required_providers {
      source = "hashicorp/aws"
      version = "~>6.28.0"
    }
}
provider "aws" {
    region = "ap-south-1"
}