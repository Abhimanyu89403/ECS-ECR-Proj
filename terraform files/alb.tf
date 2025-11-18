resource "aws_load_balancer" "alb" {
    name = " ${var.name}-alb"
    internal = false
    load_balancer_type = "applicarion"
    security_group_ids = [aws_security_group_id.alb_sg.id]
    subnets = [aws_subnet.pubsub.id]
}

resource "aws_target_group" "tg" {
    name = "${var.name}-tg"
    port = var.container_port
    target_type = "ip"
    protocol = "HTTP"
    vpc_id = aws_vpc.vpc.id
    health_check {
        path = "/"
        protocol = "HTTP"
        interval = 30
        timeout = 5
        healthy_threshold = 3
        unhealthy_threshold = 2      
    }
}

resource "aws_lb_listener" "HTTP" {
    Load_balancer_arn = aws_load_balancer.alb.arn
    port = "80"
    protocol = "HTTP"

    default_action {
    type = "forward"
    target_group_arn = aws_target_group.tg.arn
    }
}
    