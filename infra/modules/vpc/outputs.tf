output "vpc_id" {
    value = aws_vpc.main.id
}

output "public_subnet_id_A" {
  value = aws_subnet.public_a.id
}

output "public_subnet_id_C" {
  value = aws_subnet.public_c.id
}

output "private_subnet_id_A" {
    value = aws_subnet.private_a.id
}
