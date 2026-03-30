resource "aws_lb" "retail_lb" {
    name = "${var.environment}-lb"
    internal = false
    load_balancer_type = "application"
    security_groups = ["aws_security_group.lb_sg.id"]
    subnets = aws_subnet.public_subnet.id

    enable_deletion_protection = true
    enable_cross_zone_load_balancing = true

    tags = {
        owner = var.owner
        team = var.team
    }
}

resource "aws_lb_target_group" "cart_tg" {
    name = "${var.environment}-cart-tg"
    port = var.container_port
    protocol = "http"
    target_type = "ip"
    vpc_id = aws_vpc.retail_vpc.id

    health_check {
        path = "/health"
        matcher = "200"
        healthy_threshold = 2
        unhealthy_threshold = 3
        interval = 30 
    }   
}

resource "aws_lb_listener" "cart_listener" {
    load_balancer_arn = aws_lb.retail_lb.arn
    port = var.container_port
    protocol = "HTTP"

    default_action {
        type = "Forward"
        target_group_arn = aws_lb_target_group.cart_tg.arn
    }
}