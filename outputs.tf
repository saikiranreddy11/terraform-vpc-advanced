output "vpc" {
  value = aws_vpc.main
}       

output "gw"{
    value = aws_internet_gateway.gw
}

output "az"{
    value = local.allowed_availability_zones
}

output "eip"{
    value = aws_eip.roboshop_eip
}

output "public_subnet_id"{
    value = aws_subnet.public[*].id
}
output "private_subnet_id"{
    value = aws_subnet.private[*].id
}
output "database_subnet_id"{
    value = aws_subnet.database[*].id
}