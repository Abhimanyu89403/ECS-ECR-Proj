terraform {
    backend "s3" {
            bucket = "abhibuckettfstate89403-bcde"
            key = "ecs-ecr/prod/tfstate"
            region = "ap-south-1"
            encrypt = true
            use_lockfile = true
    }
}