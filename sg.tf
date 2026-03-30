resource "aws_security_group" "alb_sg" {
    name = "alb-sg"
    description = "allowing traffic from internet"
    vpc_id = aws_vpc.retail_vpc.id
    ingress {
        description = "http from internet"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }   
    egress{
        description = "allow all traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "alb-sg"
    }
}


resource "aws_security_group" "cart_sg" {
    name = "cart-ecs-service-sg"
    description = "allow traffic from lb"
    vpc_id = aws_vpc.retail_vpc.id

    ingress {
        description = "allow inbound traffic from alb to ecs"
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
