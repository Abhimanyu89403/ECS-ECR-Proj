resource "aws_security_group" "cart_sg" {
    name = "cart-ecs-service-sg"
    description = "allow traffic from lb to ecs"
    vpc_id = []

    ingress {
        from_port = 3306
        to_port = 3306
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
resource "aws_security_group" "lb_sg"{
    name = "${var.environment}-lb-sg"
    description = "allow traffic from internet to lb"
    vpc_id = []

    ingress {
        from_port = 443
        to_port = 443
        protocol = "HTTP" 
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        name = "alb-sg"
    }
}