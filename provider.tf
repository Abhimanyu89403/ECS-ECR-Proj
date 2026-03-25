terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            verison = "~>6.28.0"
        }
    }
}
provider "aws"{
    region = "ap-south-1"
}