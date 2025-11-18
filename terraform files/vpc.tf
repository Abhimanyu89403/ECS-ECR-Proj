resource "aws_vpc" "vpc" {
    cidr_block = "0.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostname = true
    tags ={
        name = ${var.name}-vpc
    }
}
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "${var.name}-igw"
    }
}



resource "aws_subnet" "pubsub" {
    vpc_id = aws_vpc.vpc.id
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "${var.name}-pubsub"
    }
}


resource "aws_route_table" "pubrt" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "${var.name}-pubrt"
    }
}
resource "aws_route" "route" {
    route_table_id = aws_route_table.pubrt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
    tags = {
        Name = "${var.name}-route"
    }
}
resource "aws-route_table_association" "pubrta"{
    vpc_id = aws_vpc.vpc.id
    subnet_id = aws_subnet.pubsub.id
    route_table_id = aws_route_table.pubrt.id
}

