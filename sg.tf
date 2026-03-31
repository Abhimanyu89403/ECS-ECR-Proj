resource "aws_security_group" "alb_sg" {
    name = "alb-${var.environment}-sg"
    description = "allow traffic from internet to lb"
    vpc_id = aws_vpc.retail_vpc.id
    ingress {
        description = "allow incoming traffic from internet to alb"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "allow"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_security_group" "cart_sg" {
    name = "cart-ecs-service-sg"
    description = "allow traffic from lb to ecs"
    vpc_id = aws_vpc.retail_vpc.id

    ingress {
        from_port = var.container_port
        to_port = var.container_port
        protocol = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
    }
    egress {
        description = "allow outbound traffic from ecr to pull images"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "ecs-sg"
    }
}