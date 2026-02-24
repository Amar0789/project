output "public_ip"{
    value = aws_instance.demo.public_ip
}

output "instance_id"{
    value = aws_instance.demo.id
}

output "vpc_id"{
    value = aws_vpc.main.id
}

output "subnet_id"{
    value = aws_subnet.public.id
}

output "aws_route_id"{
    value = aws_route_table.rt.id
}

output "gateway_id"{
    value = aws_internet_gateway.igw.id
}