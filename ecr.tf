resource "aws_ecr_repository" "cart_repo" {
    name = "cart_ecr_repo"
    image_tag_mutability = "IMMUTABLE"
    image_scanning_configuration {
      scan_on_push = true
    }
    encryption_configuration {
      encryption_type = "AES256"
    }
    tags = {
        owner = "Abhimanyu"
        team = "Devops"
    }
}
resource "aws_ecr_lifecycle_policy" "cart_repo_policy" {
    repository = aws_ecr_repository.cart_repo.name
    policy = jsonencode([
        {
            rules = {
                rulePriority = 10
                description = "Kepp 10 images"
                selection = {
                    tagStatus = "any"
                    countType = "imageCountMoreThan"
                    countNumber = 10
                }
                action = {
                    type = "expire"
                }
            }
        }
    ])
}