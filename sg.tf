resource "aws_security_group" "cart_sg" {
    name = "cart-ecs-service-sg"
    description = "allow traffic from lb to ecs"
    vpc_id = []

    ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        security_groups = [aws_security_groups.cart_sg.id]
    }
    egress {
        description = "allow outbound traffic from ecr to pull images"
        from_port = 0
        to_port = 0
        protocol = "TCP"
        security_groups = [aws_security_groups.cart_sg.id]
    }
    tags = {
        Name = "ecs-sg"
    }
}