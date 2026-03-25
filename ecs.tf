resource "aws_ecs_cluster" "retail_clust" {
    name = "retail_clust"

    tags = {
        owner = "Abhimanyu"
        team = "Devops"
    }
}

resource "aws_cloudwatch_log_group" "cart_logs" {
    name = "/ecs/cart"
    retention_in_days = 7
}

resource "aws_ecs_task_definition" "cart_task_def" {
    family = "cart_task_def"
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
    cpu = 4096
    memory = 4096
    container_definitions = jsonencode([
        {
            name = "cart_pods"
            image = "${aws_ecr_repository.cart_repo.repository_url}:Latest"
            cpu = 512
            memory = 1024
            portMappings = [{
                containerPort = 80
                hostPort = 80
        }]
            logConfiguration = {
                logDriver = "awsLogs"
                    options = {
                        awslogs-group = aws_cloudwatch_log_group.cart_logs.name
                        awsLogs-region = "ap-south-1"
                        awsLogs-stream-prefix = "ecs"
                    }
            } 
        }
    ])
}

resource "aws_ecs_service" "cart_service" {
    name = "app-service"
    cluster = aws_ecs_cluster.retail_clust.id
    task_definition = aws_ecs_task_definition.cart_task_def.arn
    launch_type = "FARGATE"
    desired_count = 3
}

resource "aws_appautoscaling_target" "cart_target"{
    max_capacity = 5
    min_capacity = 2
    resource_id = "service/${aws_ecs_cluster.retail_clust.name}/${aws_ecs_service.cart_service.name}"
    scalable_dimension = "ecs:service:desired_count"
    service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "cpu_scaling" {
    name = "cpu-scaling"
    policy_type = "TargetTrackingScaling"
    resource_id = aws_appautoscaling_target.cart_target.resource_id
    scalable_dimension = aws_appautoscaling_target.cart_target.scalable_dimension
    service_namespace = aws_appautoscaling_target.cart_target.service_namespace

    target_tracking_scaling_policy_configuration {
      target_value = 60

      predefined_metric_specification {
        predefined_metric_type = "ECSServiceAverageCPUUtilization"
      }
      scale_in_cooldown = 60
      scale_out_cooldown = 60
    }
}
