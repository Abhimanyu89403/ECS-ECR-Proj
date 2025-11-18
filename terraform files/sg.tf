resource "aws_security_group" "alb_sg" {
    name = "${var.name}-sg"
    description = "Allow HTTP/HTTPS traffic for load balancer"
    vpc_id = aws_vpc.vpc.id

    ingress {
        description = "Allow HTTP traffic"
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "ecs-sg" {
    name = "${var.name}-ecs-sg"
    description = "Allow traffic from alb to ecs tasks"
    vpc_id = aws-vpc.vpc.id

    ingess {
        description = "allow traffic from alb to ecs tasks"
        protocol = "tcp"
        from_port = var.container_port
        to_port = var.container_port
        security_groups = [aws_security_group.alb_sg.id]
    }
}