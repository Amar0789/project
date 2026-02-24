resource "aws_instance" "demo"{
    ami = var.ami_id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.allow_all.id]

    tags = {
        Name = "demo_instance"
    }
}

resource "aws_security_group" "allow_all"{
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
    vpc_id = output.vpc_id
    availability_zone = var.region
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw"{
    vpc_id = output.vpc_id
    subnet_id = output.subnet_id
}

resource "aws_route_table" "rt"{
    vpc_id = var.vpc_id
}

resource "aws_route" "r"{
    route_table_id = output.aws_route_id
    gateway_id = var.gateway_id
    destination_cidr = "0.0.0.0/0"

}

resource "aws_route_table_association" "rta"{
    route_table_id = output.aws_route_id
    subnet_id = output.subnet_id
}