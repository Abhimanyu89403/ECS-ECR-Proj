terraform {
  backend "aws" {
    bucket       = "abhibuckettfstate89403-bcde"
    key          = "ecs-ecr/dev/tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
