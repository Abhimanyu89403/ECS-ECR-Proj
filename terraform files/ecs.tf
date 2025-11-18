resource "aws_ecs_cluster" "ecs_cluster" {
    name = "${var.name}-ecs-cluster"   
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
    name = "/ecs/${var.name}-log-group"
    retention_in_days = 14
}

resource "aws_ecs_task_definition" "ecs_task" {
    required_capabilities = ["FARGATE"]
    family = "${var.name}-task-def"
    network_mode = "awsvpc"

    container_definitions = jsonencode ({
        name = "${var.name}-container"
        image = "${aws_ecr_repository.ecr-repo.repository-url:latest}"
        memory = 512
        cpu = 256
        portMappings = [
            {
                containerport = var.container_port
                hostport = var.container_port
                protocol = "tcp"
            }
        ]
        log_Configuration = {
            logDriver = "awslogs"
            option = {
                awslogs-group = aws_cloudewatch_log_group.ecs_log_group.name
                awslogs-region = var.aws_region
                awslogs-stream-prefix = var.name
            }
        }

    })
}



resource "aws_ecs_service" "ecs_service" {
    name = "${var.name}-ecs-service"
    cluster = aws_ecs_cluster.ecs_cluster.family
    task_definition = aws_ecs_task_definition.ecs_task.arn
    desired_count = 5
    Launch_type = "FARGATE"
    network_configuration {
        subnets = [aws_subnet.pubsub.id]
        security_group = aws_security_group.ecs_sg.id
        assign_public_ip = true
    }
    load_balancer {
        target_group_arn = aws_target_group.tg.arn
        container_name = "${var.name}-container"
        container_port = var.container_port
    }

    depends_on = [aws_lb_listener.HTTP]
}

