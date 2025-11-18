output "vpc_id"{
    description = ""
    value = 
}

output "alb_dns" {
    description = "The application load balancer DNS name is"
    value = aws_load_balancer.alb.dns_name
}

output "ecs_cluster_id" {
    description = ""
    value = 
}

output "ecr_repo_url" {
    description = ""
    value = 
}

