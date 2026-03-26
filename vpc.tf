resource "aws_vpc" "retail_vpc" {
    cidr_block = ["10.0.0.0/0"]
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "vpc-${var.environment}-retail"
        owner = var.owner
        team = var.team
    }
}

resource "aws_internet_gateway" "retail_igw" {
    vpc_id = aws_vpc.retail_vpc.id
    tags = {
        env  = var.environment
    }
}
resource "aws_eip" "nat_eip" {
    domain = "vpc"
    tags = {
        owner = var.owner
        team = var.team
    }
}
resource "aws_nat_gateway" "prinat" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public_subnet.id

    depends_on = [ aws_internet_gateway.retail_igw.id ]
}

resource "aws_subnet" "public_subnet" {
    map_public_ip_on_launch = true
    vpc_id = aws_vpc.retail_vpc.id
    availability_zone = "ap-south-1a"
    cidr_block = ["10.0.1.0/24"]

    tags = {
        name = "pubsub-${var.environment}-retail"
        owner = var.owner
        team = var.team
    }
}
resource "aws_route_table" "pubroutetable" {
    vpc_id = aws_vpc.retail_vpc.id
}
resource "aws_route" "pubroute" {
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.retail_igw.id
    route_table_id = aws_route_table.pubroutetable.id
}
resource "aws_route_table_association" "routesubassoc" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.pubroutetable.id
}

resource "aws_subnet" "private_subnet" {
    map_public_ip_on_launch = false
    vpc_id = aws_vpc.retail_vpc.id
    cidr_block = ["10.0.2.0/24"]
    availability_zone = "ap-south-1b"

    tags = {
        name = "prisub-${var.environment}-retail"
        owner = var.owner
        team = var.team
    }
}

resource "aws_route_table" "priroutetable" {
    vpc_id = aws_vpc.retail_vpc.id
}
resource "aws_route" "privateroute" {
    route_table_id = aws_route_table.priroutetable.id
    nat_gateway_id = aws_nat_gateway.prinat.id
    destination_cidr_block = "0.0.0.0/0"
}
resource "aws_route_table_association" "routesubassoc" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.priroutetable.id
}
