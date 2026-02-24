resource "aws_instance" "demo"{
    ami = var.ami_id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.allow_all.id]
    subnet_id = aws_subnet.public.id

    tags = {
        Name = "demo_instance"
    }
}

resource "aws_security_group" "allow_all"{
    vpc_id = aws_vpc.main.id
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}

resource "aws_vpc" "main"{
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
}

resource "aws_subnet" "public"{
    vpc_id = aws_vpc.main.id
    availability_zone = "us-east-1a"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "private"{
    vpc_id = aws_vpc.main.id
    availability_zone = "us-east-1a"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = false
}

resource "aws_internet_gateway" "igw"{
    vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "rt"{
    vpc_id = aws_vpc.main.id
}

resource "aws_route" "r"{
    route_table_id = aws_route_table.rt.id
    gateway_id = aws_internet_gateway.igw.id
    destination_cidr_block = "0.0.0.0/0"

}

resource "aws_route_table_association" "rta"{
    route_table_id = aws_route_table.rt.id
    subnet_id = aws_subnet.public.id
}

resource "aws_eip" "ep"{
    domain = "vpc"
}

resource "aws_nat_gateway" "nat"{
    allocation_id = aws_eip.ep.id
    subnet_id = aws_subnet.public.id
}

resource "aws_route_table" "rt1"{
    vpc_id = aws_vpc.main.id
}

resource "aws_route" "r1"{
    route_table_id = aws_route_table.rt1.id
    nat_gateway_id = aws_nat_gateway.nat.id
    destination_cidr_block = "0.0.0.0/0"

}

resource "aws_route_table_association" "rta1"{
    route_table_id = aws_route_table.rt1.id
    subnet_id = aws_subnet.private.id
}