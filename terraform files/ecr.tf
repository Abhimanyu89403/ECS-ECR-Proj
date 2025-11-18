resource "aws_ecr_repository" "ecr-repo" {
    name = "${var.name}-ecr-repo"
    image_tab_mutability = "IMMUTABLE"
    image_scanning_configuration {
        scan-on_push = true
    }
    encryption_configuration {
        encryption_type = "AES256"
    }
}

resource "aws_ecr_lifecycyle_policy" "ecr_policy" {
    repository = aws-ecr-repository.ecr-repo.name

    policy = jsonencode({
    rules = [
        {
            rulePriority = 1
            description = "Delete the images older than 30 days"
            selection {
                tagStatus = "any"
                countType = "sinceImageCreated"
                countUnit = "days"
                countNumber = 30
            },
            actions = {
                type = "expire"
            }
        }
    ]
    })
}