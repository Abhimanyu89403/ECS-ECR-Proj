terraform{
    backend "s3" {
        bucket = "abhibuckettfstate89403-bcde"
        key = "dockefile/terraform.tfstate"
        region = "ap-south-1"
        encrypt = true
    }
}